#include "kyber_accel_driver.h"

void kyber_encaps_hw(uint8_t *pk, uint8_t *ct, uint8_t *ss) {
    for (int i = 0; i < KYBER_PUBLIC_KEY_BYTES; i++) {
        Xil_Out8(KYBER_IP_BASE_ADDR + 0x100 + i, pk[i]);
    }

    Xil_Out32(KYBER_IP_BASE_ADDR + 0x00, 1);

    while (Xil_In32(KYBER_IP_BASE_ADDR + 0x04) != 1);

    for (int i = 0; i < KYBER_CIPHERTEXT_BYTES; i++) {
        ct[i] = Xil_In8(KYBER_IP_BASE_ADDR + 0x200 + i);
    }

    for (int i = 0; i < KYBER_SHARED_SECRET_BYTES; i++) {
        ss[i] = Xil_In8(KYBER_IP_BASE_ADDR + 0x300 + i);
    }
}
