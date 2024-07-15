#!/bin/bash

set -e  # Exit immediately if a command fails

# Install git
sudo yum install -y git

# Install CMake
echo "Installing CMake"
echo "==========================================="
sudo yum install -y gcc-c++
wget https://cmake.org/files/v3.10/cmake-3.10.0.tar.gz
tar -xvzf cmake-3.10.0.tar.gz
cd cmake-3.10.0
./bootstrap
make
sudo make install
cd ..
echo "================= CMake Installation completed =========================="

# Clone the 2048.cpp repository
git clone https://github.com/plibither8/2048.cpp
cd 2048.cpp
mkdir build
cd build
cmake ..
cmake --build .
./2048
4
exit