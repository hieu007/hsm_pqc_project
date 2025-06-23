#!/bin/bash
set -e

echo "▶️ Tạo khóa Kyber-512 và CSR..."
openssl req -new -newkey oqsdefault -algorithm kyber512 -keyout kyber.key -out kyber.csr \
  -nodes -subj "/CN=Test PQC/OU=Quantum/O=SecureNet/L=HN/C=VN"
echo "[INFO] Đã tạo khóa Kyber và CSR."

echo "[INFO] Danh sách thuật toán PQC hỗ trợ:"
openssl list -public-key-algorithms | grep kyber || true

# Mở dòng sau nếu muốn test kết nối pkcs11 sau khi cài SoftHSM và pkcs11-provider
# openssl req -engine pkcs11 -new -key "pkcs11:token=PQC-TOKEN;object=mykey;type=private" \
#   -keyform engine -out test_pqc_pkcs11.csr
