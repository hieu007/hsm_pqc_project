#!/bin/bash
set -e

echo "🚀 [1/6] Cài OpenSSL 3.0.7..."
cd ~/Desktop/HSM || mkdir -p ~/Desktop/HSM && cd ~/Desktop/HSM
wget https://www.openssl.org/source/openssl-3.0.7.tar.gz
tar -xf openssl-3.0.7.tar.gz
cd openssl-3.0.7
./config --prefix=/usr/local --openssldir=/usr/local/ssl
make -j$(nproc)
sudo make install
export PATH=/usr/local/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
openssl version -a

echo "✅ OpenSSL 3.0.7 đã cài thành công."

echo "🚀 [2/6] Cài liboqs..."
cd ~/Desktop/HSM
git clone --recursive https://github.com/open-quantum-safe/liboqs.git
cd liboqs
mkdir build && cd build
cmake -GNinja .. -DBUILD_SHARED_LIBS=ON
ninja
sudo ninja install

echo "✅ liboqs đã được cài."

echo "🚀 [3/6] Cài oqs-provider (dùng OpenSSL 3.0.7)..."
cd ~/Desktop/HSM
git clone --branch main https://github.com/open-quantum-safe/oqs-provider.git
cd oqs-provider
mkdir -p build && cd build
export OPENSSL_ROOT_DIR=/usr/local
export PATH=$OPENSSL_ROOT_DIR/bin:$PATH
export LD_LIBRARY_PATH=$OPENSSL_ROOT_DIR/lib:$LD_LIBRARY_PATH
export CMAKE_PREFIX_PATH=/usr/local
cmake .. -DOPENSSL_ROOT_DIR=$OPENSSL_ROOT_DIR
make -j$(nproc)

echo "✅ oqs-provider đã build xong."

echo "🚀 [4/6] Cài pkcs11-provider..."
sudo apt update
sudo apt install -y python3-pip git ninja-build build-essential
pip3 install --user 'meson>=0.57'
export PATH="$HOME/.local/bin:$PATH"
git clone https://github.com/latchset/pkcs11-provider.git
cd pkcs11-provider
meson setup build
ninja -C build
sudo ninja -C build install

echo "✅ pkcs11-provider đã được cài đặt."

echo "🚀 [5/6] Thiết lập SoftHSM..."
sudo apt install -y softhsm2
softhsm2-util --init-token --slot 0 --label "PQC-TOKEN" --so-pin 0000 --pin 1234
echo "[INFO] Đã tạo token PQC-TOKEN với PIN 1234."

echo "🚀 [6/6] Tạo khóa Kyber-512 và kiểm thử..."
openssl req -new -newkey oqsdefault -algorithm kyber512 -keyout kyber.key -out kyber.csr \
  -nodes -subj "/CN=Test PQC/OU=Quantum/O=SecureNet/L=HN/C=VN"
echo "[INFO] Đã tạo khóa Kyber và CSR."
echo "[INFO] Thuật toán PQC hỗ trợ:"
openssl list -public-key-algorithms | grep kyber || true

echo "🎉 Hoàn tất cài đặt và kiểm thử hệ thống HSM hỗ trợ PQC!"
