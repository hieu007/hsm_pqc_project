#!/bin/bash
# Build OQS-OpenSSL (hỗ trợ thuật toán hậu lượng tử)

set -e
git clone https://github.com/open-quantum-safe/oqs-provider.git
cd oqs-provider
mkdir build && cd build
cmake -GNinja -DOQS_PROVIDER_EXAMPLES=ON ..
ninja
sudo ninja install
