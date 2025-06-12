#!/bin/bash
# Cài đặt liboqs từ Open Quantum Safe

set -e

sudo apt update
sudo apt install -y cmake ninja-build build-essential
sudo apt install cmake
git clone --recursive https://github.com/open-quantum-safe/liboqs.git
cd liboqs
mkdir build && cd build
cmake -GNinja .. -DBUILD_SHARED_LIBS=ON
ninja
sudo ninja install
