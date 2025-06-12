#!/bin/bash
# install_pkcs11_provider.sh — Build & install pkcs11-provider trên Ubuntu 20.04

set -e

# 1. Cập nhật gói, cài các dependency cơ bản
sudo apt update
sudo apt install -y python3-pip git ninja-build build-essential

# 2. Cài Meson mới (>=0.57) qua pip vào thư mục ~/.local
pip3 install --user 'meson>=0.57'

# 3. Đưa Meson vừa cài vào PATH cho phiên làm việc này
export PATH="$HOME/.local/bin:$PATH"

# (Tuỳ chọn) Kiểm tra phiên bản Meson
echo "Meson version:" && meson --version

# 4. Clone và build pkcs11-provider
git clone https://github.com/latchset/pkcs11-provider.git
cd pkcs11-provider

# Dùng meson setup (thay cho 'meson build' nếu chưa có thư mục build)
meson setup build
ninja -C build

# 5. Cài vào hệ thống
sudo ninja -C build install

echo "✅ pkcs11-provider đã được cài thành công!"
