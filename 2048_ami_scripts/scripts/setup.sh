#!/bin/bash

# Install git
sudo yum install -y git

# Clone repository with automatic "yes" response
if git clone https://github.com/plibither8/2048.cpp.git; then
    echo "Repository cloned successfully."
else
    echo "Failed to clone the repository."
    exit 1
fi

pwd

# Install Dependencies
sudo yum install -y gcc-c++ cmake

# Build 2048 code
cd 2048.cpp
mkdir -p build
cd build
cmake .. || { echo "Failed to configure with CMake"; exit 1; }
cmake --build . || { echo "Failed to build project"; exit 1; }

exit 0
