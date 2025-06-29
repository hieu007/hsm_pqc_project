#!/bin/bash
set -e
# Setup liboqs
echo "▶️ Installing liboqs..."
sudo apt update
sudo apt install -y cmake ninja-build build-essential

git clone --recursive https://github.com/open-quantum-safe/liboqs.git
cd liboqs
mkdir build && cd build
cmake -GNinja .. -DBUILD_SHARED_LIBS=ON
ninja
sudo ninja install
