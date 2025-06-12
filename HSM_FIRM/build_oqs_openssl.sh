#!/bin/bash
# Build OQS-OpenSSL (hỗ trợ thuật toán hậu lượng tử)

set -e

sudo apt install -y git libssl-dev

git clone --branch OQS-OpenSSL_1_1_1-stable https://github.com/open-quantum-safe/oqs-openssl.git
cd oqs-openssl
./Configure linux-x86_64 -lm
make -j$(nproc)
sudo make install
