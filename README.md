# HSM PQC Project

Dự án này bao gồm:

- Client Python giao tiếp với HSM qua UART.
- Firmware C cho FPGA Zynq xử lý thuật toán Kyber512.

## Cấu trúc thư mục

- `python_client/`: chứa mã Python client.
- `zynq_firmware/`: chứa firmware C cho Zynq.

## Ví dụ mã nguồn Python

```python
def send_command(cmd, payload):
    # Gửi lệnh tới HSM
    pass

Hướng dẫn sử dụng
Cài đặt thư viện Python: pip install pyserial

Chạy client: python python_client/main.py --port /dev/ttyUSB0 --pk pubkey.bin --encapsulate
