# Cài các gói cần thiết
sudo apt update
sudo apt install cmake build-essential ninja-build libssl-dev

# Clone liboqs và build
git clone --recursive https://github.com/open-quantum-safe/liboqs.git
cd liboqs
mkdir build && cd build
cmake -GNinja .. -DOQS_USE_OPENSSL=ON -DBUILD_SHARED_LIBS=ON
ninja
sudo ninja install
# Clone và build OQS-OpenSSL (tùy chỉnh OpenSSL hỗ trợ PQC)
cd ~
git clone --branch OQS-OpenSSL_1_1_1-stable https://github.com/open-quantum-safe/oqs-openssl.git
cd oqs-openssl
./Configure linux-x86_64 -lm
make -j$(nproc)
sudo make install
