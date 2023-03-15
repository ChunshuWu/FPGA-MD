# FPGA-MD
This project is developed based on [Xilinx XUP project](https://github.com/Xilinx/xup_vitis_network_example), and implemented for Alveo U280 boards.  
The design is tested on Massachusetts cluster on [cloudlab](https://www.cloudlab.us/)  
A simple demo is provided (for 2 U280 boards). 
## Overview
This project aims to accelerate Range-Limited interactions among particles in a simulation space with cut-off. During runtime, the current position data of each particle is used to calculate the resulting force applied to it. These forces are then transformed into velocity differences using classical physics. The particle velocities and positions are then updated from their current values to determine their values in the next time step.  
  
The demo provided allows 2 FPGA nodes run the processes described above separately with static communications (Cross-board initialization and data dumping). 27 cells (the small cubes below in the figure) are mapped onto an FPGA. The dynamic communication version (multiple boards running on a larger simulation space together) is not yet released.  
<img src="https://github.com/ChunshuWu/FPGA-MD/blob/main/cell_intro.png" width=600>  
The initial particles are arranged as the figure shows below (in 2-D illustration). Generally speaking, each cell only contains ~60 particles (~4 particles along a diagonal line) in water environment, the demo is an extreme case that 15 particles are aligned on a diagonal line of a cell (illustrated below), where the symmetry should be perfect. However, because of the overly high energy, eventually the oscillation of particles is broken due to the amplification of small error. This demo is just to intuitively show how the particles behave.  
<img src="https://github.com/ChunshuWu/FPGA-MD/blob/main/demo.png" width=300>  
Some example demo results:  
<img src="https://github.com/ChunshuWu/FPGA-MD/blob/main/velocity_demo.png" width=1000>  
## How to Run the Demo
### Environment Requirements
For [cloudlab](https://www.cloudlab.us/) users:  
Book 2 nodes with Alveo U280 FPGAs on a switch, run  
`$FPGA-MD/InterFPGA_MD/upload.sh <node ID>`  
for each node to upload host code and the `.xclbin` file onto the nodes.  
Note that the username and server IP in `upload.sh` need to be modified.  
  
The environment can be automatically configured with FPGA-MD/InterFPGA_MD/Notebooks/config.sh on [cloudlab](https://www.cloudlab.us/). To manually configure, we recommend having the following packages installed:  
```
python: python3.8  
click: 7+  
dask: 2.9.2  
pynq: 2.8.0.dev0  
ipython  
numpy: 1.19  
```
Dask installation can be exempted if two boards are directly connected, but the host code may be subject to changes. 
  
### Host Communication Establishment
Open a terminal on node 0, run  
`$dask-scheduler`  
A scheduler url will show up below, copy it (see the figure below).  
<img src="https://github.com/ChunshuWu/FPGA-MD/blob/main/dask_scheduler.png" width=1500> 
  
Then open a terminal for each node, run  
`$dask-worker <scheduler url>`  
on each node and keep all 3 terminals on hold.  
  
### Run the Demo
Open another terminal for node 0, run  
`$python3 FPGA-MD/InterFPGA_MD/Notebooks/run.py <scheduler url> <dump group ID> <number of iterations>`  
`dump group` can be from 0 to 7, which is to configure which group of cells (4 cells for each group) would the user like to dump. For the demo, we recommend trying `dump group = 0` and `number of iterations = 1~10000`.  
  
The resulting data are dumped to `FPGA-MD/InterFPGA_MD/Notebooks/recv_local_bank_<dump group ID>_<number of iterations>.txt` and `recv_remote_bank_<dump group ID>_<number of iterations>.txt`.  
  
To restart, run  
`xbutil reset -d 0`  
on both nodes to reset the FPGAs. 
## For Developers
To compile, run  
`$FPGA-MD/InterFPGA_MD/compile.sh`  
## Architecture

## Performance

## To do
User interface: Use '.pdb' file to initialize particle positions, velocities, and element types
