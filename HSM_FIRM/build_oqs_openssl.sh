#!/bin/bash
set -e

# 1. Tải và build liboqs
echo "Cloning and building liboqs..."
cd ~/Desktop/HSM
git clone --branch main https://github.com/open-quantum-safe/liboqs.git
cd liboqs
mkdir -p build && cd build
cmake -DCMAKE_INSTALL_PREFIX=/opt/liboqs ..
make -j$(nproc)
sudo make install

# 2. Tải và build oqs-provider
echo "Cloning and building oqs-provider..."
cd ~/Desktop/HSM
git clone --branch main https://github.com/open-quantum-safe/oqs-provider.git
cd oqs-provider
mkdir -p build && cd build

# 3. Cấu hình biến môi trường
export OPENSSL_ROOT_DIR=/opt/openssl3
export PATH=$OPENSSL_ROOT_DIR/bin:$PATH
export LD_LIBRARY_PATH=$OPENSSL_ROOT_DIR/lib:$LD_LIBRARY_PATH
export CMAKE_PREFIX_PATH=/opt/liboqs

# 4. Build oqs-provider
cmake .. -DOPENSSL_ROOT_DIR=$OPENSSL_ROOT_DIR
make -j$(nproc)

echo "✅ Build hoàn tất!"
