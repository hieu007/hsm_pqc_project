#!/bin/bash
set -e

echo "▶️ Downloading OpenSSL 3.0.7..."
cd ~/Desktop/HSM
wget https://www.openssl.org/source/openssl-3.0.7.tar.gz
tar -xf openssl-3.0.7.tar.gz
cd openssl-3.0.7

echo "▶️ Building OpenSSL 3.0.7..."
./config --prefix=/usr/local --openssldir=/usr/local/ssl
make -j$(nproc)
sudo make install

echo "▶️ Exporting OpenSSL environment..."
export PATH=/usr/local/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

# Kiểm tra lại phiên bản
openssl version -a
