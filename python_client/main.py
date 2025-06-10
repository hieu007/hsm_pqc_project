import argparse
from hsm_interface import HSMInterface
from protocol import *

def load_public_key(filename):
    with open(filename, "rb") as f:
        pk = f.read()
    if len(pk) != KYBER_PUBLIC_KEY_BYTES:
        raise ValueError("Sai kích thước public key!")
    return pk

def main():
    parser = argparse.ArgumentParser(description="HSM PQC Client")
    parser.add_argument("--port", type=str, default="/dev/ttyUSB0", help="Cổng nối với HSM (mặc định /dev/ttyUSB0)")
    parser.add_argument("--pk", type=str, help="Đường dẫn file chứa public key")
    parser.add_argument("--encapsulate", action="store_true", help="Thực hiện encapsulate Kyber512")
    args = parser.parse_args()

    hsm = HSMInterface(port=args.port)

    if args.pk:
        pk = load_public_key(args.pk)
        print("[>] Gửi public key tới HSM...")
        hsm.send_command(CMD_SEND_PK, pk)

    if args.encapsulate:
        print("[>] Gửi lệnh yêu cầu encapsulate...")
        hsm.send_command(CMD_ENCAPSULATE)

        print("[<] Đang chờ kết quả...")
        cmd, payload = hsm.receive_response()
        if cmd != CMD_GET_RESULT:
            print("Lệnh phản hồi không hợp lệ!")
        else:
            ct = payload[:KYBER_CIPHERTEXT_BYTES]
            ss = payload[KYBER_CIPHERTEXT_BYTES:]
            print("==> Ciphertext:\n", ct.hex())
            print("==> Shared Secret:\n", ss.hex())

    hsm.close()

if __name__ == "__main__":
    main()
