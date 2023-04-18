#!/bin/bash
sudo apt -y install python3.8
sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 2
sudo apt -y install python3-pip
pip3 install --upgrade pip
pip3 install "click>=7,<8"
pip3 install "dask[complete]"==2.9.2
pip3 install pynq==2.8.0.dev0
pip3 install ipython
pip3 install numpy=='1.19'
