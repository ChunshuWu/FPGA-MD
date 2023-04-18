#!/bin/bash
ssh -o "ProxyCommand ssh -i ~/Documents/pvtkey -W %h:%p <username>@<server_name>" -i ~/Documents/pvtkey <username>@$1.cloudlab.umass.edu 'mkdir ~/benchmark.intf0.xilinx_u280_xdma_201920_3'
#source /opt/xilinx/xrt/setup.sh
scp -o "ProxyCommand ssh -i ~/Documents/pvtkey <username>@<server_name> nc %h %p" -i ~/Documents/pvtkey benchmark.intf0.xilinx_u280_xdma_201920_3/vnx_benchmark_if0.xclbin <username>@$1.cloudlab.umass.edu:~/benchmark.intf0.xilinx_u280_xdma_201920_3/vnx_benchmark_if0.xclbin
scp -o "ProxyCommand ssh -i ~/Documents/pvtkey <username>@<server_name> nc %h %p" -i ~/Documents/pvtkey -r Notebooks <username>@$1.cloudlab.umass.edu:~
