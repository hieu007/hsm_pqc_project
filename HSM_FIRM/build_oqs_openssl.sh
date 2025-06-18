#!/bin/bash
set -e

#To upgrade OpenSSL from 1.1.1f to 3.0.7 on Ubuntu 20.04
sudo apt remove --purge openssl libssl-dev

sudo apt autoremove

sudo apt update
sudo apt install build-essential checkinstall zlib1g-dev

sudo apt install --reinstall ca-certificates

wget https://www.openssl.org/source/openssl-3.0.7.tar.gz

tar -xvf openssl-3.0.7.tar.gz
cd openssl-3.0.7

./config --prefix=/usr/local/openssl --openssldir=/usr/local/openssl
make

sudo make install

echo "export OPENSSL_ROOT_DIR=/usr/local/openssl" >> ~/.bashrc
echo "export PATH=/usr/local/openssl/bin:$PATH" >> ~/.bashrc
echo "export LD_LIBRARY_PATH=/usr/local/openssl/lib:$LD_LIBRARY_PATH" >> ~/.bashrc
source ~/.bashrc

sudo update-alternatives --install /usr/bin/openssl openssl /usr/local/openssl/bin/openssl 1
sudo update-alternatives --config openssl

sudo ldconfig

sudo apt install libssl-dev



# 1. Tải và build liboqs
#echo "Cloning and building liboqs..."
#cd ~/Desktop/HSM
#git clone --branch main https://github.com/open-quantum-safe/liboqs.git
#cd liboqs
#mkdir -p build && cd build
#cmake -DCMAKE_INSTALL_PREFIX=/opt/liboqs ..
#make -j$(nproc)
#sudo make install

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
