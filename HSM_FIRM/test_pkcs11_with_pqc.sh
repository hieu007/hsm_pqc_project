#!/bin/bash
# Tạo khóa PQC và kiểm thử giao tiếp HSM qua PKCS#11

set -e

# Tạo khóa Kyber-512
openssl req -new -newkey oqsdefault -algorithm kyber512 -keyout kyber.key -out kyber.csr \
  -nodes -subj "/CN=Test PQC/OU=Quantum/O=SecureNet/L=HN/C=VN"

echo "[INFO] Đã tạo khóa Kyber và CSR."

# Test liệt kê thuật toán PQC
echo "[INFO] Danh sách thuật toán PQC:"
openssl list -public-key-algorithms | grep kyber || true

# Test kết nối pkcs11 (chỉ nếu đã cấu hình đúng URI)
# openssl req -engine pkcs11 -new -key "pkcs11:token=PQC-TOKEN;object=mykey;type=private" \
#   -keyform engine -out test_pqc_pkcs11.csr
