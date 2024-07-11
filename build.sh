#!/bin/bash

# Update package list and upgrade all packages
sudo apt update -y
sudo apt-get install cmake

git clone https://github.com/plibither8/2048.cpp
cd 2048.cpp
ctest -S setup.cmake
cmake --install build
2048