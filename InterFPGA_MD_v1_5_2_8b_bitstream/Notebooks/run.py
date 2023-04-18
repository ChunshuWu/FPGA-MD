from MD_ctrl import *
from dask.distributed import Client, get_client
from dummy_packet_gen import *
from pynq.pl_server.xrt_device import XrtStream
from vnx_utils import *
import ctypes
import os
import platform
import pynq
import re
import sys
import tempfile
import time

buffers = []


def verify_workers():
    node_name = platform.node()
    shell_version = os.popen("xbutil dump | grep dsa_name").read()
    return node_name, shell_version[24:-2]

# Functions that will be called in the context of dask
def _invalidate(bo, offset, size):
    buf = bytearray(size)
    pynq.Device.active_device.invalidate(bo, offset, 0, size)
    pynq.Device.active_device.buffer_read(bo, offset, buf)
    return bytes(buf)


def _flush(bo, offset, size, data):
    pynq.Device.active_device.buffer_write(bo, offset, bytearray(data))
    pynq.Device.active_device.flush(bo, offset, 0, size)


def _read_registers(address, length):
    return pynq.Device.active_device.read_registers(address, length)


def _write_registers(address, data):
    pynq.Device.active_device.write_registers(address, data)


def _download(bitstream_data):
    with tempfile.NamedTemporaryFile() as f:
        f.write(bitstream_data)
        f.flush()
        ol = pynq.Overlay(f.name)


def _alloc(size, memdesc):
    mem = pynq.Device.active_device.get_memory(memdesc)
    buf = mem.allocate((size,), 'u1')
    buffers.append(buf)
    return buf.bo, buf.device_address


class DaskMemory:
    """Memory object proxied over dask

    """
    def __init__(self, device, desc):
        self._desc = desc
        self._device = device

    def allocate(self, shape, dtype):
        from pynq.buffer import PynqBuffer
        buf = PynqBuffer(shape, dtype, device_address=0,
                         bo=0, device=self._device, coherent=False)
        bo, addr = self._device._call_dask(_alloc, buf.nbytes, self._desc)
        buf.bo = bo
        buf.device_address = addr
        return buf


class DaskDevice(pynq.Device):
    """PYNQ Proxy device for using PYNQ via dask

    """
    def __init__(self, client, worker):
        """The worker ID should be unique

        """
        super().__init__("dask-" + re.sub(r'[^\w]', '_', worker))
        self._dask_client = client
        self._worker = worker
        self.capabilities = {
            'REGISTER_RW': True,
            'CALLABLE': True
        }
        self._streams = {}
        self.sync_to_device = self.flush
        self.sync_from_device = self.invalidate

    def _call_dask(self, func, *args):
        future = self._dask_client.submit(func, *args, workers=self._worker,
                                          pure=False)
        return future.result()

    def invalidate(self, bo, offset, ptr, size):
        """Copy buffer from the device to the host
        """

        ctype = ctypes.c_uint8 * size
        target = ctype.from_address(ptr)
        target[:] = self._call_dask(_invalidate, bo, offset, size)

    def flush(self, bo, offset, ptr, size):
        """Copy buffer from the host to the device
        """

        ctype = ctypes.c_uint8 * size
        target = ctype.from_address(ptr)
        self._call_dask(_flush, bo, offset, size, bytes(target))

    def read_registers(self, address, length):
        return self._call_dask(_read_registers, address, length)

    def write_registers(self, address, data):
        self._call_dask(_write_registers, address, bytes(data))

    def get_bitfile_metadata(self, bitfile_name):
        return pynq.pl_server.xclbin_parser.XclBin(bitfile_name)

    def open_context(self, description, shared=True):
        return pynq.Device.active_device.open_context(description, shared)

    def close_context(self, cu_name):
        pynq.Device.active_device.close_context(cu_name)

    def download(self, bitstream, parser=None):
        with open(bitstream.bitfile_name, 'rb') as f:
            bitstream_data = f.read()
        self._call_dask(_download, bitstream_data)
        super().post_download(bitstream, parser)

    def get_memory(self, desc):
        if desc['streaming']:
            if desc['idx'] not in self._streams:
                self._streams[desc['idx']] = XrtStream(self, desc)
            return self._streams[desc['idx']]
        else:
            return DaskMemory(self, desc)

    def get_memory_by_idx(self, idx):
        for m in self.mem_dict.values():
            if m['idx'] == idx:
                return self.get_memory(m)
        raise RuntimeError("Could not find memory")


num_cells = 8
num_particles = 64

# Dask setup
scheduler_url = str(sys.argv[1])
dump_bank_sel = int(sys.argv[2])
iter_target = int(sys.argv[3])
client = Client(scheduler_url)
client_info = client.scheduler_info()['workers']
workers = []
for cli in client_info:
    workers.append(client_info[cli]['name'])

if len(workers) != 8:
    print("Configure your Dask cluster with 8 workers")

worker_0 = client.submit(verify_workers ,workers=workers[0], pure=False)
worker_1 = client.submit(verify_workers ,workers=workers[1], pure=False)
worker_2 = client.submit(verify_workers ,workers=workers[2], pure=False)
worker_3 = client.submit(verify_workers ,workers=workers[3], pure=False)
worker_4 = client.submit(verify_workers ,workers=workers[4], pure=False)
worker_5 = client.submit(verify_workers ,workers=workers[5], pure=False)
worker_6 = client.submit(verify_workers ,workers=workers[6], pure=False)
worker_7 = client.submit(verify_workers ,workers=workers[7], pure=False)
worker_check = [worker_0.result(),worker_1.result(),worker_2.result(),worker_3.result(),worker_4.result(),worker_5.result(),worker_6.result(),worker_7.result()]
for w in worker_check:
    print('Worker name: {} | shell version: {}'.format(w[0],w[1]))

daskdev = []
for w in workers:
    daskdev.append(DaskDevice(client, w))

# Board init
ol_w0, ol_w1, ol_w2, ol_w3, ol_w4, ol_w5, ol_w6, ol_w7 = init_network(daskdev)
ol_w0_md = init_kernel(ol_w0, 0, iter_target)
ol_w1_md = init_kernel(ol_w1, 1, iter_target)
ol_w2_md = init_kernel(ol_w2, 2, iter_target)
ol_w3_md = init_kernel(ol_w3, 3, iter_target)
ol_w4_md = init_kernel(ol_w4, 4, iter_target)
ol_w5_md = init_kernel(ol_w5, 5, iter_target)
ol_w6_md = init_kernel(ol_w6, 6, iter_target)
ol_w7_md = init_kernel(ol_w7, 7, iter_target)
print("Boards initialized. ")

XCV_COOLDOWN = 3
# set data sending cooldown
ol_w0_md.register_map.xcv_cooldown_cycles = XCV_COOLDOWN
ol_w1_md.register_map.xcv_cooldown_cycles = XCV_COOLDOWN
ol_w2_md.register_map.xcv_cooldown_cycles = XCV_COOLDOWN
ol_w3_md.register_map.xcv_cooldown_cycles = XCV_COOLDOWN
ol_w4_md.register_map.xcv_cooldown_cycles = XCV_COOLDOWN
ol_w5_md.register_map.xcv_cooldown_cycles = XCV_COOLDOWN
ol_w6_md.register_map.xcv_cooldown_cycles = XCV_COOLDOWN
ol_w7_md.register_map.xcv_cooldown_cycles = XCV_COOLDOWN

ol_w0_md.register_map.init_npc = num_particles
ol_w1_md.register_map.init_npc = num_particles
ol_w2_md.register_map.init_npc = num_particles
ol_w3_md.register_map.init_npc = num_particles
ol_w4_md.register_map.init_npc = num_particles
ol_w5_md.register_map.init_npc = num_particles
ol_w6_md.register_map.init_npc = num_particles
ol_w7_md.register_map.init_npc = num_particles

ol_w0_md.register_map.dump_bank_sel = dump_bank_sel
ol_w1_md.register_map.dump_bank_sel = dump_bank_sel
ol_w2_md.register_map.dump_bank_sel = dump_bank_sel
ol_w3_md.register_map.dump_bank_sel = dump_bank_sel
ol_w4_md.register_map.dump_bank_sel = dump_bank_sel
ol_w5_md.register_map.dump_bank_sel = dump_bank_sel
ol_w6_md.register_map.dump_bank_sel = dump_bank_sel
ol_w7_md.register_map.dump_bank_sel = dump_bank_sel

# Placeholder, should add another parameter for it
ol_w0_md.register_map.dump_filter_sel = dump_bank_sel
ol_w1_md.register_map.dump_filter_sel = dump_bank_sel
ol_w2_md.register_map.dump_filter_sel = dump_bank_sel
ol_w3_md.register_map.dump_filter_sel = dump_bank_sel
ol_w4_md.register_map.dump_filter_sel = dump_bank_sel
ol_w5_md.register_map.dump_filter_sel = dump_bank_sel
ol_w6_md.register_map.dump_filter_sel = dump_bank_sel
ol_w7_md.register_map.dump_filter_sel = dump_bank_sel

# Pos init
ol_w0_md.register_map.MD_state = 1   # 0: IDLE; 1: INIT; 2: READY_TO_RECV; 3: RUN
ol_w1_md.register_map.MD_state = 1
ol_w2_md.register_map.MD_state = 1
ol_w3_md.register_map.MD_state = 1
ol_w4_md.register_map.MD_state = 1
ol_w5_md.register_map.MD_state = 1
ol_w6_md.register_map.MD_state = 1
ol_w7_md.register_map.MD_state = 1

time.sleep(2)

mm2s = init_pos(ol_w0, num_cells, num_particles, 0)  # 2^22 4194304
mm2s = init_pos(ol_w1, num_cells, num_particles, 1)  # 2^21 2097152
mm2s = init_pos(ol_w2, num_cells, num_particles, 2)  # 2^21 2097152
mm2s = init_pos(ol_w3, num_cells, num_particles, 3)  # 2^21 2097152
mm2s = init_pos(ol_w4, num_cells, num_particles, 4)  # 2^22 4194304
mm2s = init_pos(ol_w5, num_cells, num_particles, 5)  # 2^21 2097152
mm2s = init_pos(ol_w6, num_cells, num_particles, 6)  # 2^21 2097152
mm2s = init_pos(ol_w7, num_cells, num_particles, 7)  # 2^21 2097152

print("Pos initialized. ")
print()
print("w0 in traffic size in 512", check_status(ol_w0_md, "in_traffic_bytes_pos")/64)
print("w1 in traffic size in 512", check_status(ol_w1_md, "in_traffic_bytes_pos")/64)
print("w2 in traffic size in 512", check_status(ol_w2_md, "in_traffic_bytes_pos")/64)
print("w3 in traffic size in 512", check_status(ol_w3_md, "in_traffic_bytes_pos")/64)
print("w4 in traffic size in 512", check_status(ol_w4_md, "in_traffic_bytes_pos")/64)
print("w5 in traffic size in 512", check_status(ol_w5_md, "in_traffic_bytes_pos")/64)
print("w6 in traffic size in 512", check_status(ol_w6_md, "in_traffic_bytes_pos")/64)
print("w7 in traffic size in 512", check_status(ol_w7_md, "in_traffic_bytes_pos")/64)
print("w0 out traffic size in 512", check_status(ol_w0_md, "out_traffic_bytes_pos")/64)
print("w1 out traffic size in 512", check_status(ol_w1_md, "out_traffic_bytes_pos")/64)
print("w2 out traffic size in 512", check_status(ol_w2_md, "out_traffic_bytes_pos")/64)
print("w3 out traffic size in 512", check_status(ol_w3_md, "out_traffic_bytes_pos")/64)
print("w4 out traffic size in 512", check_status(ol_w4_md, "out_traffic_bytes_pos")/64)
print("w5 out traffic size in 512", check_status(ol_w5_md, "out_traffic_bytes_pos")/64)
print("w6 out traffic size in 512", check_status(ol_w6_md, "out_traffic_bytes_pos")/64)
print("w7 out traffic size in 512", check_status(ol_w7_md, "out_traffic_bytes_pos")/64)
print()
time.sleep(2)

# Recv step 0
s2mm_w0, s2mm_buf_w0 = init_recv(ol_w0, num_particles)
s2mm_w1, s2mm_buf_w1 = init_recv(ol_w1, num_particles)
s2mm_w2, s2mm_buf_w2 = init_recv(ol_w2, num_particles)
s2mm_w3, s2mm_buf_w3 = init_recv(ol_w3, num_particles)
s2mm_w4, s2mm_buf_w4 = init_recv(ol_w4, num_particles)
s2mm_w5, s2mm_buf_w5 = init_recv(ol_w5, num_particles)
s2mm_w6, s2mm_buf_w6 = init_recv(ol_w6, num_particles)
s2mm_w7, s2mm_buf_w7 = init_recv(ol_w7, num_particles)
time.sleep(2)

# Ready to perform MD
ol_w0_md.register_map.MD_state = 2
ol_w1_md.register_map.MD_state = 2
ol_w2_md.register_map.MD_state = 2
ol_w3_md.register_map.MD_state = 2
ol_w4_md.register_map.MD_state = 2
ol_w5_md.register_map.MD_state = 2
ol_w6_md.register_map.MD_state = 2
ol_w7_md.register_map.MD_state = 2
time.sleep(2)

# Start MD, and dump automatically starts at iter_cnt == iter_target
ol_w0_md.register_map.MD_state = 3
ol_w1_md.register_map.MD_state = 3
ol_w2_md.register_map.MD_state = 3
ol_w3_md.register_map.MD_state = 3
ol_w4_md.register_map.MD_state = 3
ol_w5_md.register_map.MD_state = 3
ol_w6_md.register_map.MD_state = 3
ol_w7_md.register_map.MD_state = 3

timeout = 0
while (int(ol_w0_md.register_map.iter_cnt) < iter_target or int(ol_w1_md.register_map.iter_cnt) < iter_target or int(ol_w2_md.register_map.iter_cnt) < iter_target or int(ol_w3_md.register_map.iter_cnt) < iter_target or int(ol_w4_md.register_map.iter_cnt) < iter_target or int(ol_w5_md.register_map.iter_cnt) < iter_target or int(ol_w6_md.register_map.iter_cnt) < iter_target or int(ol_w7_md.register_map.iter_cnt) < iter_target ):
    timeout += 1
    if timeout > 5:
        print("MD iteration timed out")
        break
    time.sleep(1)
time.sleep(1)

start_recv(s2mm_buf_w0, "dump/recv_w0_bank_"+str(dump_bank_sel)+"_"+str(iter_target)+".txt")
start_recv(s2mm_buf_w1, "dump/recv_w1_bank_"+str(dump_bank_sel)+"_"+str(iter_target)+".txt")
start_recv(s2mm_buf_w2, "dump/recv_w2_bank_"+str(dump_bank_sel)+"_"+str(iter_target)+".txt")
start_recv(s2mm_buf_w3, "dump/recv_w3_bank_"+str(dump_bank_sel)+"_"+str(iter_target)+".txt")
start_recv(s2mm_buf_w4, "dump/recv_w4_bank_"+str(dump_bank_sel)+"_"+str(iter_target)+".txt")
start_recv(s2mm_buf_w5, "dump/recv_w5_bank_"+str(dump_bank_sel)+"_"+str(iter_target)+".txt")
start_recv(s2mm_buf_w6, "dump/recv_w6_bank_"+str(dump_bank_sel)+"_"+str(iter_target)+".txt")
start_recv(s2mm_buf_w7, "dump/recv_w7_bank_"+str(dump_bank_sel)+"_"+str(iter_target)+".txt")

print("Step 0 received. ")

print()
print("w0 still receiving: ", s2mm_w0.register_map.CTRL.AP_START)
print("w1 still receiving: ", s2mm_w1.register_map.CTRL.AP_START)
print("w2 still receiving: ", s2mm_w2.register_map.CTRL.AP_START)
print("w3 still receiving: ", s2mm_w3.register_map.CTRL.AP_START)
print("w4 still receiving: ", s2mm_w4.register_map.CTRL.AP_START)
print("w5 still receiving: ", s2mm_w5.register_map.CTRL.AP_START)
print("w6 still receiving: ", s2mm_w6.register_map.CTRL.AP_START)
print("w7 still receiving: ", s2mm_w7.register_map.CTRL.AP_START)

print()
w_pos_in = 0
w_pos_out = 0
w_frc_in = 0
w_frc_out = 0
w_pos_in += check_status(ol_w0_md, "in_traffic_bytes_pos")/64
w_pos_in += check_status(ol_w1_md, "in_traffic_bytes_pos")/64
w_pos_in += check_status(ol_w2_md, "in_traffic_bytes_pos")/64
w_pos_in += check_status(ol_w3_md, "in_traffic_bytes_pos")/64
w_pos_in += check_status(ol_w4_md, "in_traffic_bytes_pos")/64
w_pos_in += check_status(ol_w5_md, "in_traffic_bytes_pos")/64
w_pos_in += check_status(ol_w6_md, "in_traffic_bytes_pos")/64
w_pos_in += check_status(ol_w7_md, "in_traffic_bytes_pos")/64
w_pos_out += check_status(ol_w0_md, "out_traffic_bytes_pos")/64
w_pos_out += check_status(ol_w1_md, "out_traffic_bytes_pos")/64
w_pos_out += check_status(ol_w2_md, "out_traffic_bytes_pos")/64
w_pos_out += check_status(ol_w3_md, "out_traffic_bytes_pos")/64
w_pos_out += check_status(ol_w4_md, "out_traffic_bytes_pos")/64
w_pos_out += check_status(ol_w5_md, "out_traffic_bytes_pos")/64
w_pos_out += check_status(ol_w6_md, "out_traffic_bytes_pos")/64
w_pos_out += check_status(ol_w7_md, "out_traffic_bytes_pos")/64
w_frc_in += check_status(ol_w0_md, "in_traffic_bytes_frc")/64
w_frc_in += check_status(ol_w1_md, "in_traffic_bytes_frc")/64
w_frc_in += check_status(ol_w2_md, "in_traffic_bytes_frc")/64
w_frc_in += check_status(ol_w3_md, "in_traffic_bytes_frc")/64
w_frc_in += check_status(ol_w4_md, "in_traffic_bytes_frc")/64
w_frc_in += check_status(ol_w5_md, "in_traffic_bytes_frc")/64
w_frc_in += check_status(ol_w6_md, "in_traffic_bytes_frc")/64
w_frc_in += check_status(ol_w7_md, "in_traffic_bytes_frc")/64
w_frc_out += check_status(ol_w0_md, "out_traffic_bytes_frc")/64
w_frc_out += check_status(ol_w1_md, "out_traffic_bytes_frc")/64
w_frc_out += check_status(ol_w2_md, "out_traffic_bytes_frc")/64
w_frc_out += check_status(ol_w3_md, "out_traffic_bytes_frc")/64
w_frc_out += check_status(ol_w4_md, "out_traffic_bytes_frc")/64
w_frc_out += check_status(ol_w5_md, "out_traffic_bytes_frc")/64
w_frc_out += check_status(ol_w6_md, "out_traffic_bytes_frc")/64
w_frc_out += check_status(ol_w7_md, "out_traffic_bytes_frc")/64
print("w0 in pos traffic size in 512", check_status(ol_w0_md, "in_traffic_bytes_pos")/64)
print("w1 in pos traffic size in 512", check_status(ol_w1_md, "in_traffic_bytes_pos")/64)
print("w2 in pos traffic size in 512", check_status(ol_w2_md, "in_traffic_bytes_pos")/64)
print("w3 in pos traffic size in 512", check_status(ol_w3_md, "in_traffic_bytes_pos")/64)
print("w4 in pos traffic size in 512", check_status(ol_w4_md, "in_traffic_bytes_pos")/64)
print("w5 in pos traffic size in 512", check_status(ol_w5_md, "in_traffic_bytes_pos")/64)
print("w6 in pos traffic size in 512", check_status(ol_w6_md, "in_traffic_bytes_pos")/64)
print("w7 in pos traffic size in 512", check_status(ol_w7_md, "in_traffic_bytes_pos")/64)
print("w0 out pos traffic size in 512", check_status(ol_w0_md, "out_traffic_bytes_pos")/64)
print("w1 out pos traffic size in 512", check_status(ol_w1_md, "out_traffic_bytes_pos")/64)
print("w2 out pos traffic size in 512", check_status(ol_w2_md, "out_traffic_bytes_pos")/64)
print("w3 out pos traffic size in 512", check_status(ol_w3_md, "out_traffic_bytes_pos")/64)
print("w4 out pos traffic size in 512", check_status(ol_w4_md, "out_traffic_bytes_pos")/64)
print("w5 out pos traffic size in 512", check_status(ol_w5_md, "out_traffic_bytes_pos")/64)
print("w6 out pos traffic size in 512", check_status(ol_w6_md, "out_traffic_bytes_pos")/64)
print("w7 out pos traffic size in 512", check_status(ol_w7_md, "out_traffic_bytes_pos")/64)

print()
print("w0 in frc traffic size in 512", check_status(ol_w0_md, "in_traffic_bytes_frc")/64)
print("w1 in frc traffic size in 512", check_status(ol_w1_md, "in_traffic_bytes_frc")/64)
print("w2 in frc traffic size in 512", check_status(ol_w2_md, "in_traffic_bytes_frc")/64)
print("w3 in frc traffic size in 512", check_status(ol_w3_md, "in_traffic_bytes_frc")/64)
print("w4 in frc traffic size in 512", check_status(ol_w4_md, "in_traffic_bytes_frc")/64)
print("w5 in frc traffic size in 512", check_status(ol_w5_md, "in_traffic_bytes_frc")/64)
print("w6 in frc traffic size in 512", check_status(ol_w6_md, "in_traffic_bytes_frc")/64)
print("w7 in frc traffic size in 512", check_status(ol_w7_md, "in_traffic_bytes_frc")/64)
print("w0 out frc traffic size in 512", check_status(ol_w0_md, "out_traffic_bytes_frc")/64)
print("w1 out frc traffic size in 512", check_status(ol_w1_md, "out_traffic_bytes_frc")/64)
print("w2 out frc traffic size in 512", check_status(ol_w2_md, "out_traffic_bytes_frc")/64)
print("w3 out frc traffic size in 512", check_status(ol_w3_md, "out_traffic_bytes_frc")/64)
print("w4 out frc traffic size in 512", check_status(ol_w4_md, "out_traffic_bytes_frc")/64)
print("w5 out frc traffic size in 512", check_status(ol_w5_md, "out_traffic_bytes_frc")/64)
print("w6 out frc traffic size in 512", check_status(ol_w6_md, "out_traffic_bytes_frc")/64)
print("w7 out frc traffic size in 512", check_status(ol_w7_md, "out_traffic_bytes_frc")/64)

print()
print("all pos in", w_pos_in)
print("all pos out", w_pos_out)
print("all frc in", w_frc_in)
print("all frc out", w_frc_out)

print()
print(ol_w0_md.register_map)
print()
print()
print(ol_w1_md.register_map)
print()
print()
print(ol_w2_md.register_map)
print()
print()
print(ol_w3_md.register_map)
print()
print()
print(ol_w4_md.register_map)
print()
print()
print(ol_w5_md.register_map)
print()
print()
print(ol_w6_md.register_map)
print()
print()
print(ol_w7_md.register_map)
