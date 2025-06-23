#!/bin/bash
set -e

echo "▶️ Cloning and building oqs-provider..."
cd ~/Desktop/HSM
git clone --branch main https://github.com/open-quantum-safe/oqs-provider.git
cd oqs-provider
mkdir -p build && cd build

# Thiết lập biến môi trường cho OpenSSL 3.0.7 (cài ở /usr/local)
export OPENSSL_ROOT_DIR=/usr/local
export PATH=$OPENSSL_ROOT_DIR/bin:$PATH
export LD_LIBRARY_PATH=$OPENSSL_ROOT_DIR/lib:$LD_LIBRARY_PATH
export CMAKE_PREFIX_PATH=/usr/local

cmake .. -DOPENSSL_ROOT_DIR=$OPENSSL_ROOT_DIR
make -j$(nproc)
