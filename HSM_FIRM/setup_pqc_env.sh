#!/bin/bash
# Cài đặt liboqs, oqs-openssl và pkcs11-provider cho PQC + HSM test

set -e  # Dừng nếu có lỗi

sudo apt update
sudo apt install -y build-essential cmake ninja-build git libssl-dev softhsm2

# Clone liboqs
git clone --recursive https://github.com/open-quantum-safe/liboqs.git
cd liboqs && mkdir build && cd build
cmake -GNinja .. -DBUILD_SHARED_LIBS=ON
ninja && sudo ninja install
cd ../..

# Clone và build oqs-openssl
git clone --branch OQS-OpenSSL_1_1_1-stable https://github.com/open-quantum-safe/oqs-openssl.git
cd oqs-openssl
./Configure linux-x86_64
make -j$(nproc) && sudo make install
