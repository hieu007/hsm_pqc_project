#ifndef KYBER_ACCEL_DRIVER_H
#define KYBER_ACCEL_DRIVER_H

#include "xil_io.h"
#include "xparameters.h"

#define KYBER_IP_BASE_ADDR XPAR_KYBER_ENCAPS_HW_0_S00_AXI_BASEADDR

void kyber_encaps_hw(uint8_t *pk, uint8_t *ct, uint8_t *ss);

#endif
