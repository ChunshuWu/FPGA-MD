#!/bin/bash
python3 ./sys_param_config.py -nlc $1 -ngc $2
make all DEVICE=xilinx_u280_xdma_201920_3 INTERFACE=0 DESIGN=benchmark
