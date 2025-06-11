# HSM PQC Project

Dự án này bao gồm:

- Client Python giao tiếp với HSM qua UART.
- Firmware C cho FPGA Zynq xử lý thuật toán Kyber512.

## Cấu trúc thư mục

- `python_client/`: chứa mã Python client.
- `zynq_firmware/`: chứa firmware C cho Zynq.
- `crypto/`: chứa tài liệu các thuật toán mã hóa cho HSM.

## Ví dụ mã nguồn Python

```python
def send_command(cmd, payload):
    # Gửi lệnh tới HSM
    pass

Hướng dẫn sử dụng
Cài đặt thư viện Python: pip install pyserial

Chạy client: python python_client/main.py --port /dev/ttyUSB0 --pk pubkey.bin --encapsulate
**Kyber**
Kyber là một hệ mật mã khóa công khai dựa trên lưới, thuộc bộ thuật toán CRYSTALS (Cryptographic Suite for Algebraic Lattices). Đây là cơ chế đóng gói khóa (Key Encapsulation Mechanism – KEM) có khả năng chống lại các cuộc tấn công từ máy tính lượng tử. Kyber sử dụng cấu trúc toán học của lưới như một nguyên thủy mật mã và nổi bật nhờ tốc độ xử lý nhanh hơn so với các hệ mật mã khóa công khai truyền thống như RSA.

Thuật toán này dựa trên bài toán LWE (Learning with Errors), trong đó việc rút ra thông tin bí mật từ các hệ phương trình tuyến tính có nhiễu là cực kỳ khó, đảm bảo tính bảo mật cao. LWE hiện cũng được ứng dụng trong học máy và lý thuyết mật mã.

Năm 2022, Kyber đã được NIST lựa chọn là một trong những thuật toán mật mã hậu lượng tử tiêu chuẩn. Ba biến thể của Kyber gồm Kyber-512, Kyber-768 và Kyber-1024, được thiết kế với các mức độ an toàn khác nhau.

Kyber và bộ CRYSTALS được phát triển bởi một nhóm nghiên cứu được tài trợ bởi Liên minh Châu Âu và một số chính phủ châu Âu. Tuy nhiên, vào tháng 2 năm 2023, các nhà nghiên cứu tại Viện Công nghệ Hoàng gia Thụy Điển đã công bố một cuộc tấn công kênh bên thành công vào Kyber, sử dụng kỹ thuật học sâu để khai thác thông tin từ việc thực thi thuật toán.
