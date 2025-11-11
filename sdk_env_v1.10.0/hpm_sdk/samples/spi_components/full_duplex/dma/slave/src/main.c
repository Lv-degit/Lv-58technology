/*
 * Copyright (c) 2024 HPMicro
 *
 * SPDX-License-Identifier: BSD-3-Clause
 *
 */

#include "hpm_dma_mgr.h"
#include "hpm_spi.h"
#include "board.h"


#include "hpm_gpio_drv.h"
#include "hpm_gpiom_drv.h"


#define TEST_SPI                    HPM_SPI2  //BOARD_APP_SPI_BASE
#define TEST_SPI_DATA_LEN_BITS      (8U)
#define TEST_SPI_DATA_LEN_BYTES     ((TEST_SPI_DATA_LEN_BITS + 7) / 8)


#define _BUFFER_CONCAT3(x, y, z)     x ## y ## z
#define BUFFER_CONCAT3(x, y, z)     _BUFFER_CONCAT3(x, y, z)

#if ((TEST_SPI_DATA_LEN_BYTES * 8) == 8)
#define TEST_SPI_DATA_TYPE_SIZE     8
#elif ((TEST_SPI_DATA_LEN_BYTES * 8) == 16)
#define TEST_SPI_DATA_TYPE_SIZE     16
#else
#define TEST_SPI_DATA_TYPE_SIZE     32
#endif

#define TEST_TRANSFER_DATA_COUNT  (10U)
typedef BUFFER_CONCAT3(uint, TEST_SPI_DATA_TYPE_SIZE, _t)  buffer_type;

ATTR_PLACE_AT_NONCACHEABLE  buffer_type sent_buff[TEST_TRANSFER_DATA_COUNT];
ATTR_PLACE_AT_NONCACHEABLE  buffer_type receive_buff[TEST_TRANSFER_DATA_COUNT];

static void prepare_transfer_data(void);
static void spi_check_transfer_data(void);

static volatile bool rxdma_complete;
static volatile bool txdma_complete;

void spi_rxdma_complete_callback(uint32_t channel)
{
    (void)channel;
    rxdma_complete = true;
}

void spi_txdma_complete_callback(uint32_t channel)
{
    (void)channel;
    txdma_complete = true;
}


void init_pins(void)
{
    HPM_IOC->PAD[IOC_PAD_PC29].FUNC_CTL = IOC_PC29_FUNC_CTL_SPI2_MOSI;

    HPM_IOC->PAD[IOC_PAD_PC28].FUNC_CTL = IOC_PC28_FUNC_CTL_SPI2_MISO;

    HPM_IOC->PAD[IOC_PAD_PC26].FUNC_CTL = IOC_PC26_FUNC_CTL_SPI2_SCLK | IOC_PAD_FUNC_CTL_LOOP_BACK_MASK;

    HPM_IOC->PAD[IOC_PAD_PC27].FUNC_CTL = IOC_PC27_FUNC_CTL_SPI2_CS_0;

           /* set max frequency slew rate(200M) */
    HPM_IOC->PAD[IOC_PAD_PC27].PAD_CTL = IOC_PAD_PAD_CTL_SR_MASK | IOC_PAD_PAD_CTL_SPD_SET(3) | IOC_PAD_PAD_CTL_PE_SET(1) | IOC_PAD_PAD_CTL_PS_SET(1) | IOC_PAD_PAD_CTL_PRS_SET(1);
    HPM_IOC->PAD[IOC_PAD_PC26].PAD_CTL = IOC_PAD_PAD_CTL_SR_MASK | IOC_PAD_PAD_CTL_SPD_SET(3);
    HPM_IOC->PAD[IOC_PAD_PC28].PAD_CTL = IOC_PAD_PAD_CTL_SR_MASK | IOC_PAD_PAD_CTL_SPD_SET(3);
    HPM_IOC->PAD[IOC_PAD_PC29].PAD_CTL = IOC_PAD_PAD_CTL_SR_MASK | IOC_PAD_PAD_CTL_SPD_SET(3);
}

void init_pins_io(void)
{
   //灯程序初始化
    HPM_IOC->PAD[IOC_PAD_PD00].FUNC_CTL = IOC_PD00_FUNC_CTL_GPIO_D_00;

    gpiom_set_pin_controller(HPM_GPIOM, GPIOM_ASSIGN_GPIOD, 0, gpiom_core0_fast);
    gpio_set_pin_output(HPM_FGPIO, GPIO_OE_GPIOD, 0);
    gpio_write_pin(HPM_FGPIO, GPIO_DO_GPIOD, 0, 1);
}




int main(void)
{
    spi_initialize_config_t init_config;
    board_init();
    printf("full_duplex spi slave use dma\n");
    board_init_spi_clock(TEST_SPI);
    /* pins init, hardware CS pin must be set for slave mode*/
   // board_init_spi_pins(TEST_SPI);
    init_pins_io();
    init_pins();

    dma_mgr_init();
    hpm_spi_get_default_init_config(&init_config);
    init_config.direction = spi_msb_first;
    init_config.mode = spi_slave_mode;
    init_config.clk_phase = spi_sclk_sampling_odd_clk_edges;
    init_config.clk_polarity = spi_sclk_low_idle;
    init_config.data_len = TEST_SPI_DATA_LEN_BITS;
    /* step.1  initialize spi */
    if (hpm_spi_initialize(TEST_SPI, &init_config) != status_success) {
        printf("hpm_spi_initialize fail\n");
        while (1) {
        }
    }

   

//    while (rxdma_complete == false) {
//    };
//    while (txdma_complete == false) {
//   };
    rxdma_complete = false;
    txdma_complete = false;

    gpio_write_pin(HPM_FGPIO, GPIO_DO_GPIOD, 0, 1);
    while(1)
    {

     /* step.2 install dma callback if want use dma */
    if (hpm_spi_dma_mgr_install_callback(TEST_SPI, spi_txdma_complete_callback, spi_rxdma_complete_callback) != status_success) {
        printf("hpm_spi_dma_mgr_install_callback fail\n");
        while (1) {
        }
    }

    /* step.3 full duplex, only support spi_single_io_mode */
    rxdma_complete = false;
    txdma_complete = false;
    prepare_transfer_data();
    if (hpm_spi_transmit_receive_nonblocking(TEST_SPI, (uint8_t *)sent_buff, (uint8_t *)receive_buff, sizeof(sent_buff)) != status_success) {
        printf("hpm_spi_transmit_receive_nonblocking fail\n");
        while (1) {
        }
    } 


        spi_check_transfer_data();
    }
}

static void prepare_transfer_data(void)
{
    for (uint32_t i = 0; i < sizeof(sent_buff); i++) {
        sent_buff[i] = i % 0xFFFFFFFF;
    }
    memset(receive_buff, 0, sizeof(receive_buff));
}

static void spi_check_transfer_data(void)
{
    uint32_t i = 0U, error_count = 0U;
    printf("The sent data are:");
    for (i = 0; i < sizeof(sent_buff) / sizeof(buffer_type); i++) 
    {
        if ((i & 0x0FU) == 0U) {
            printf("\r\n");
        }
        printf("0x%x ", sent_buff[i]);
    }
    printf("\n");
    printf("The received data are:");
    for (i = 0; i < sizeof(receive_buff) / sizeof(buffer_type); i++) {
        if ((i & 0x0FU) == 0U) {
            printf("\n");
        }
        printf("0x%x ", receive_buff[i]);
        if (0 != receive_buff[i]) {
            error_count++;
        }
    }
    printf("\n");
    if (error_count == 0) {

        printf("spi   error!!!!\n");
    } else {

        gpio_write_pin(HPM_FGPIO, GPIO_DO_GPIOD, 0, 1);
        board_delay_ms(100);
        gpio_write_pin(HPM_FGPIO, GPIO_DO_GPIOD, 0, 0);
        board_delay_ms(100);
    }
}





