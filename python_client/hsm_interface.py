import serial
import struct
from protocol import *

class HSMInterface:
    def __init__(self, port="/dev/ttyUSB0", baudrate=115200):
        self.ser = serial.Serial(port, baudrate, timeout=2)

    def send_command(self, cmd_type, payload=b''):
        length = len(payload)
        header = struct.pack("<BH", cmd_type, length)
        packet = header + payload
        self.ser.write(packet)

    def receive_response(self):
        header = self.ser.read(3)
        if len(header) < 3:
            raise Exception("Timeout: không nhận được phản hồi")
        cmd_type, length = struct.unpack("<BH", header)
        payload = self.ser.read(length)
        if len(payload) != length:
            raise Exception("Thiếu dữ liệu phản hồi")
        return cmd_type, payload

    def close(self):
        self.ser.close()

