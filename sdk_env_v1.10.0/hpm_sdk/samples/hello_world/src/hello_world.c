/*
 * Copyright (c) 2021 HPMicro
 *
 * SPDX-License-Identifier: BSD-3-Clause
 *
 */

#include <stdio.h>
#include "board.h"
#include "hpm_debug_console.h"

#define LED_FLASH_PERIOD_IN_MS 300
#include "board.h"
#include "hpm_gpio_drv.h"
#include "hpm_gpiom_drv.h"


void init_pins(void)
{
 //   HPM_IOC->PAD[IOC_PAD_PA05].FUNC_CTL = IOC_PA05_FUNC_CTL_GPIO_A_05;

 //   gpiom_set_pin_controller(HPM_GPIOM, GPIOM_ASSIGN_GPIOA, 5, gpiom_soc_gpio0);
 //   gpio_set_pin_output(HPM_GPIO0, GPIO_OE_GPIOA, 5);
 //   gpio_write_pin(HPM_GPIO0, GPIO_DO_GPIOA, 5, 1);

//    HPM_IOC->PAD[IOC_PAD_PD00].FUNC_CTL = IOC_PD00_FUNC_CTL_GPIO_D_00;

//    gpiom_set_pin_controller(HPM_GPIOM, GPIOM_ASSIGN_GPIOD, 00, gpiom_soc_gpio0);
//    gpio_set_pin_output(HPM_GPIO0, GPIO_OE_GPIOD, 0);
//    gpio_write_pin(HPM_GPIO0, GPIO_DO_GPIOD, 0, 1);

    HPM_IOC->PAD[IOC_PAD_PD00].FUNC_CTL = IOC_PD00_FUNC_CTL_GPIO_D_00;

    gpiom_set_pin_controller(HPM_GPIOM, GPIOM_ASSIGN_GPIOD, 0, gpiom_core0_fast);
    gpio_set_pin_output(HPM_FGPIO, GPIO_OE_GPIOD, 0);
    gpio_write_pin(HPM_FGPIO, GPIO_DO_GPIOD, 0, 1);
}

int main(void)
{
//    int u;
    board_init();
    board_init_led_pins();
    init_pins();

    board_timer_create(LED_FLASH_PERIOD_IN_MS, board_led_toggle);

    printf("hello world\n");
    while(1)
    {
        gpio_write_pin(HPM_FGPIO, GPIO_DO_GPIOD, 0, 1);
        board_delay_ms(100);
        gpio_write_pin(HPM_FGPIO, GPIO_DO_GPIOD, 0, 0);
        board_delay_ms(100);
    //    u = getchar();
    //    if (u == '\r') {
   //         u = '\n';
   //     }
   //     printf
   //     ("%c", u);
    }
    return 0;
}
