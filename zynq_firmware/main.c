#include "xuartps.h"
#include "xil_printf.h"
#include "hsm_protocol.h"
#include "kyber_accel_driver.h"
#include <string.h>

XUartPs uart;
uint8_t pk[KYBER_PUBLIC_KEY_BYTES];
uint8_t ct[KYBER_CIPHERTEXT_BYTES];
uint8_t ss[KYBER_SHARED_SECRET_BYTES];

void recv_bytes(uint8_t *buf, u32 len) {
    u32 rcv = 0;
    while (rcv < len) {
        rcv += XUartPs_Recv(&uart, buf + rcv, len - rcv);
    }
}

void send_bytes(uint8_t *buf, u32 len) {
    XUartPs_Send(&uart, buf, len);
}

int main() {
    XUartPs_Config *cfg = XUartPs_LookupConfig(XPAR_XUARTPS_0_DEVICE_ID);
    XUartPs_CfgInitialize(&uart, cfg, cfg->BaseAddress);

    xil_printf("HSM PQC Firmware started\n");

    while (1) {
        uint8_t header[3];
        recv_bytes(header, 3);

        uint8_t cmd = header[0];
        uint16_t length = header[1] | (header[2] << 8);

        if (cmd == CMD_SEND_PK && length == KYBER_PUBLIC_KEY_BYTES) {
            recv_bytes(pk, length);
            xil_printf("[HSM] Public key received\n");

        } else if (cmd == CMD_ENCAPSULATE) {
            xil_printf("[HSM] Running encapsulate...\n");
            kyber_encaps_hw(pk, ct, ss);
            xil_printf("[HSM] Done\n");

            uint8_t outbuf[KYBER_CIPHERTEXT_BYTES + KYBER_SHARED_SECRET_BYTES];
            memcpy(outbuf, ct, KYBER_CIPHERTEXT_BYTES);
            memcpy(outbuf + KYBER_CIPHERTEXT_BYTES, ss, KYBER_SHARED_SECRET_BYTES);

            uint8_t resp_header[3] = {CMD_GET_RESULT, sizeof(outbuf) & 0xFF, (sizeof(outbuf) >> 8)};
            send_bytes(resp_header, 3);
            send_bytes(outbuf, sizeof(outbuf));
        }
    }

    return 0;
}
