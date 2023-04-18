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

# the entire array should have the length of multiples of 512
def gen_dummy_packet(start,num_particles):
    arr = np.zeros((num_particles+1, 16), dtype=np.uint32)
    for j in range(16):
        arr[0][j] = num_particles
    for i in range(0, num_particles):
        for j in range(16):
            arr[i+1][j] = i+start+j*524288
    return arr.flatten()

def gen_reference_packet(num_particles):
    arr = np.zeros((num_particles+1, 16), dtype=np.uint32)
    for j in range(16):
        arr[0][j] = num_particles
    for i in range(0, num_particles):
        for j in range(4):	# 4 cells per update
            arr[i+1][4*j] = 524288*(i+1)
            arr[i+1][4*j+1] = 524288*(i+1)
            arr[i+1][4*j+2] = 524288*(i+1)
            arr[i+1][4*j+3] = 1
    return arr.flatten()
'''
def gen_reference_packet(start, num_particles):
    arr = np.zeros((num_particles+1, 16), dtype=np.uint32)
    for j in range(16):
        arr[0][j] = num_particles
    for i in range(0, num_particles//2):
        for j in range(2):
            # home xyz
            arr[i+1][8*j] = 524288//4*(i+1)
            arr[i+1][8*j+1] = 524288//4*(i+1)
            arr[i+1][8*j+2] = 524288//4*(i+1)
            # home element
            arr[i+1][8*j+3] = 1
            # nb xyz
            arr[i+1][8*j+4] = 524288//4*(i+1)
            arr[i+1][8*j+5] = 524288//4*(i+1)
            arr[i+1][8*j+6] = 524288//4*(i+1)
            # nb element
            arr[i+1][8*j+7] = 1
    for i in range(0, num_particles//2):
        for j in range(2):
            # home xyz
            arr[i+1][8*j] = 8388608-524288//4*(i+1)
            arr[i+1][8*j+1] = 8388608-524288//4*(i+1)
            arr[i+1][8*j+2] = 8388608-524288//4*(i+1)
            # home element
            arr[i+1][8*j+3] = 1
            # nb xyz
            arr[i+1][8*j+4] = 8388608-524288//4*(i+1)
            arr[i+1][8*j+5] = 8388608-524288//4*(i+1)
            arr[i+1][8*j+6] = 8388608-524288//4*(i+1)
            # nb element
            arr[i+1][8*j+7] = 1
    return arr.flatten()
'''

def init_network(daskdev):

    xclbin = '../benchmark.intf0.xilinx_u280_xdma_201920_3/vnx_benchmark_if0.xclbin'
    ol_w0 = pynq.Overlay(xclbin, device=daskdev[0])
    ol_w1 = pynq.Overlay(xclbin, device=daskdev[1])

    ol_w0.cmac_0.rsfec = False
    ol_w1.cmac_0.rsfec = False

# Only used without dask
#    ol_w0 = pynq.Overlay(xclbin,device=pynq.Device.devices[0])
#    ol_w1 = pynq.Overlay(xclbin,device=pynq.Device.devices[1])

    ol_w1.networklayer_0.set_ip_address('192.168.0.51', debug=True)
    ol_w0.networklayer_0.set_ip_address('192.168.0.52', debug=True)
    ol_w1.networklayer_1.set_ip_address('192.168.0.53', debug=True)
    ol_w0.networklayer_1.set_ip_address('192.168.0.54', debug=True)

    ol_w1.networklayer_0.sockets[1] = ('192.168.0.52', 62177, 60512, True)
    ol_w0.networklayer_0.sockets[7] = ('192.168.0.51', 60512, 62177, True)
    ol_w1.networklayer_1.sockets[1] = ('192.168.0.54', 62178, 60513, True)
    ol_w0.networklayer_1.sockets[7] = ('192.168.0.53', 60513, 62178, True)

    ol_w1.networklayer_0.populate_socket_table()
    ol_w0.networklayer_0.populate_socket_table()
    ol_w1.networklayer_1.populate_socket_table()
    ol_w0.networklayer_1.populate_socket_table()

    ol_w1.networklayer_0.arp_discovery()
    ol_w0.networklayer_0.arp_discovery()
    ol_w1.networklayer_1.arp_discovery()
    ol_w0.networklayer_1.arp_discovery()

    ol_w1.networklayer_0.get_arp_table()
    ol_w0.networklayer_0.get_arp_table()
    ol_w1.networklayer_1.get_arp_table()
    ol_w0.networklayer_1.get_arp_table()

    return ol_w0, ol_w1

#print(ol_w0.networklayer_0.get_network_info())

def init_kernel(ol, net_init_id: int=0, iter_target: int=1):
    ol_md = ol.MD_RL_0_0
#    ol_md.register_map.init_step = 0
    ol_md.start(MDMode.IDLE, net_init_id, iter_target)
    return ol_md

def init_pos(ol, num_cells: int=0, num_particles: int=0, dest_id: int=0):
    ''' MD_state and init_step need to be pre-set. This function simply sends '''
    mm2s_local = ol.krnl_mm2s_0
    mm2s_bank_local = ol.HBM0
    arr = gen_reference_packet(num_particles)
    particle_arr = list(arr)*((num_cells+3)//4)
    size = len(particle_arr)
    mm2s_buf_local = pynq.allocate(4*size, dtype=np.uint8, target=mm2s_bank_local)
    cast_32_to_8(particle_arr, mm2s_buf_local)
    mm2s_buf_local.sync_to_device()
    time.sleep(1)
    mm2s_local.start(mm2s_buf_local, 4*size, dest_id)
    time.sleep(1)
    return mm2s_buf_local
"""
def init_pos(ol, num_start: int=0, num_particles: int=0, dest_id: int=0):
    ''' MD_state and init_step need to be pre-set. This function simply sends '''
    mm2s_local = ol.krnl_mm2s_0
    mm2s_bank_local = ol.HBM0
    arr = gen_reference_packet(num_start, num_particles)
    size = len(arr)
    mm2s_buf_local = pynq.allocate(4*size, dtype=np.uint8, target=mm2s_bank_local)
    cast_32_to_8(arr, mm2s_buf_local)
    #mm2s_buf_local[:] = arr
    mm2s_buf_local.sync_to_device()
    time.sleep(1)
    mm2s_local.start(mm2s_buf_local, 4*size, dest_id)
#    mm2s_local.start_sw(mm2s_buf_local, 4*size, dest_id, ap_ctrl=0x81)
#    time.sleep(1)
    return mm2s_buf_local
"""

def init_recv(ol, num_pos: int=0):
    size = num_pos * 16
    s2mm = ol.krnl_s2mm_0
    s2mm_bank = ol.HBM0
    s2mm_buf = pynq.allocate(size, dtype=np.uint32, target=s2mm_bank)
    s2mm.start(s2mm_buf, 4*size)
    time.sleep(1)
    return s2mm, s2mm_buf

def start_recv(s2mm_buf, fname: str=""):
    s2mm_buf.sync_from_device()
    time.sleep(1)
    with open(fname, 'w') as f:
        for i in range(len(s2mm_buf)//4):
            '''
            f.write(str(s2mm_buf[4*i])+'\n')
            f.write(str(s2mm_buf[4*i+1])+'\n')
            f.write(str(s2mm_buf[4*i+2])+'\n')
            f.write(str(s2mm_buf[4*i+3])+'\n')
            '''
            f.write("{:.6f}".format(ctypes.c_float.from_buffer(ctypes.c_uint32(s2mm_buf[4*i])).value)+'\n')
            f.write("{:.6f}".format(ctypes.c_float.from_buffer(ctypes.c_uint32(s2mm_buf[4*i+1])).value)+'\n')
            f.write("{:.6f}".format(ctypes.c_float.from_buffer(ctypes.c_uint32(s2mm_buf[4*i+2])).value)+'\n')
            f.write("{:.2f}".format(s2mm_buf[4*i+3])+'\n')
            f.write('\n')
    #np.savetxt(fname, s2mm_buf, fmt='%10.5f')
    print(s2mm_buf)

def check_status(ol_md, attr):
    output = int(getattr(ol_md.register_map, attr))
    return(output)

def cast_32_to_8(array_32, array_8):
    for i in range(len(array_32)):
        for j in range(3):
            array_8[4*i+j] = array_32[i]//int(2**(8*j))%int(2**(8*(j+1)))
        array_8[4*i+3] = array_32[i] // int(2**24)



