#!/bin/bash
# Cài pkcs11-provider để kết nối PQC với PKCS#11

set -e

sudo apt install -y meson ninja-build

git clone https://github.com/latchset/pkcs11-provider.git
cd pkcs11-provider
meson build
ninja -C build
sudo ninja -C build install
