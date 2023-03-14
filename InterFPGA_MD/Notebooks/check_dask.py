import sys
from dask.distributed import Client, get_client

client = Client(str(sys.argv[1]))
client_info = client.scheduler_info()['workers']
workers = []
for cli in client_info:
    workers.append(client_info[cli]['name'])

if len(workers) != 2:
    print("Configure your Dask cluster with two workers")

import platform, os

def verify_workers():
    node_name = platform.node()
    shell_version = os.popen("xbutil dump | grep dsa_name").read()
    return node_name, shell_version[24:-2]

worker_0 = client.submit(verify_workers ,workers=workers[0], pure=False)
worker_1 = client.submit(verify_workers ,workers=workers[1], pure=False)

worker_check = [worker_0.result(),worker_1.result()]

for w in worker_check:
    print('Worker name: {} | shell version: {}'.format(w[0],w[1]))

from vnx_utils import *
import pynq

#   Copyright (c) 2022, Xilinx, Inc.
#   All rights reserved.
#
#   Redistribution and use in source and binary forms, with or without
#   modification, are permitted provided that the following conditions are met:
#
#   1.  Redistributions of source code must retain the above copyright notice,
#       this list of conditions and the following disclaimer.
#
#   2.  Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#
#   3.  Neither the name of the copyright holder nor the names of its
#       contributors may be used to endorse or promote products derived from
#       this software without specific prior written permission.
#
#   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
#   AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
#   THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
#   PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
#   CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
#   EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
#   PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
#   OR BUSINESS INTERRUPTION). HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
#   WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
#   OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
#   ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

__author__ = "Peter Ogden, Mario Ruiz"
__copyright__ = "Copyright 2022, Xilinx Inc."
__email__ = "pynq_support@xilinx.com"

import ctypes
import tempfile
import re
from pynq.pl_server.xrt_device import XrtStream

""" Simple logic to use Dask on top of pynq """

# Hold references to buffers to avoid them being collected
# Won't be visible in the process but is an easy way to
# let workers hold on to local references
buffers = []


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

daskdev_w0 = DaskDevice(client, workers[0])
daskdev_w1 = DaskDevice(client, workers[1])

xclbin = '../benchmark.intf0.xilinx_u280_xdma_201920_3/vnx_benchmark_if0.xclbin'
ol_w0 = pynq.Overlay(xclbin, device=daskdev_w0)
ol_w1 = pynq.Overlay(xclbin, device=daskdev_w1)

ol_w0.cmac_0.rsfec = False
ol_w1.cmac_0.rsfec = False

print("Link worker 0 {}; link worker 1 {}".format(ol_w0.cmac_0.link_status(),ol_w1.cmac_0.link_status()))

ip_w0 , ip_w1 = '10.1.212.199' , '10.1.212.190'
if_status_w0 = ol_w0.networklayer_0.set_ip_address(ip_w0, debug=True)
if_status_w1 = ol_w1.networklayer_0.set_ip_address(ip_w1, debug=True)
print("Worker 0: {}\nWorker 1: {}".format(if_status_w0, if_status_w1))

ol_w1.networklayer_0.sockets[3] = (ip_w0, 62177, 60512, True)
ol_w1.networklayer_0.populate_socket_table()
ol_w1.networklayer_0.arp_discovery()
ol_w1.networklayer_0.get_arp_table()

ol_w0.networklayer_0.sockets[12] = (ip_w1, 60512, 62177, True)
ol_w0.networklayer_0.populate_socket_table()
ol_w0.networklayer_0.arp_discovery()
ol_w0.networklayer_0.get_arp_table()


