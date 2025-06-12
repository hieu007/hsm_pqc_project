#!/bin/bash
# Thiết lập SoftHSM và tạo token để lưu khóa PQC

set -e

sudo apt install -y softhsm2

# Khởi tạo token
softhsm2-util --init-token --slot 0 --label "PQC-TOKEN" --so-pin 0000 --pin 1234

echo "[INFO] Đã tạo SoftHSM token với PIN 1234."
