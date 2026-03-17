/*
 *  Copyright 2010 by Texas Instruments Incorporated.
 *  All rights reserved. Property of Texas Instruments Incorporated.
 *  Restricted rights to use, duplicate or disclose this code are
 *  granted through contract.
 *
 */
/***************************************************************************/
/*                                                                         */
/*     H E L L O . C                                                       */
/*                                                                         */
/*     Basic LOG event operation from main.                                */
/*                                                                         */
/***************************************************************************/

#include <std.h>

#include <log.h>

#include "hellocfg.h"

#include "framework.h"

#define BIT0 0x01
#define BIT1 0x02
#define BIT2 0x04
#define BIT3 0x08
#define BIT4 0x10
#define BIT5 0x20
#define BIT6 0x40
#define BIT7 0x80

#define BUFFLEN 32768


int16_t sampBuffer[BUFFLEN] = {0};
uint16_t buff_idx_ptr = 0;
volatile int16_t s16;
volatile int16_t y16 = 0;

/*
 *  ======== main ========
 */
void main(void)
{
    LOG_printf(&trace, "hello world!");

    //BINTEN
    initAll();

    /* fall into DSP/BIOS idle loop */
    return;
}

void dipPRD(void){

    uint32_t dip_status;
    DIP_getAll(&dip_status);
    uint32_t mask =  (BIT0 | BIT1 | BIT5 | BIT6 | BIT7);

    if (dip_status == mask){
        LED_toggle(LED_1);
        LED_turnOff(LED_2);
    } else {
        LED_toggle(LED_2);
        LED_turnOff(LED_1);
    }


}

void processSamp(void){


    buff_idx_ptr = (buff_idx_ptr++ & BUFFLEN);

    uint32_t dip_status;
    DIP_getAll(&dip_status);
    uint32_t mask = (BIT0 | BIT1);

    uint32_t dip_val = dip_status & mask;

    switch (dip_val){
    case 1:
        sampBuffer[buff_idx_ptr] = s16;
        y16 = s16;
        break;
    case 3:
        y16 = sampBuffer[buff_idx_ptr];
        break;
    default:
        y16 = 0;
        break;
    }



}

void audioHWI(void){

    //volatile int16_t s16;
    s16 = read_audio_sample();
    write_audio_sample(y16);
    SWI_post(&SWI0);

}

