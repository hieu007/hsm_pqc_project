echo "🚀 Kiểm thử truy cập khóa PQC qua pkcs11 URI..."

# Tạo file cấu hình engine nếu cần
cat <<EOF > openssl-pkcs11.cnf
openssl_conf = openssl_init

[openssl_init]
engines = engine_section

[engine_section]
pkcs11 = pkcs11_section

[pkcs11_section]
engine_id = pkcs11
dynamic_path = /usr/lib/x86_64-linux-gnu/engines-3/pkcs11.so
MODULE_PATH = /usr/lib/softhsm/libsofthsm2.so
init = 0
EOF

# Set biến môi trường để dùng config
export OPENSSL_CONF=$(pwd)/openssl-pkcs11.cnf

# Tạo CSR qua pkcs11 (giả sử đã có key "mykey" lưu trong token)
# Đây là bước mô phỏng. Nếu bạn đã lưu khóa vào token, hãy dùng dòng sau:
# openssl req -engine pkcs11 -new -key "pkcs11:token=PQC-TOKEN;object=mykey;type=private" \
#   -keyform engine -out test_pqc_pkcs11.csr

echo "❗ Chú ý: Đây là test giả lập, chưa ghi khóa thực sự vào token."
echo "✅ Nếu bạn có công cụ để import key vào HSM, hãy sửa phần pkcs11:token=..."

echo "🎉 Kiểm thử pkcs11 hoàn tất (mức cấu hình)."
