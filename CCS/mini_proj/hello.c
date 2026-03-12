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

#define BUFFLEN 64


int16_t s16;
float sampBuffer[BUFFLEN] = {0};
uint16_t buff_idx_ptr = 0;

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

    do {
        SEM_pend(&sem, SYS_FOREVER);
        uint16_t sample = s16;
        sampBuffer[buff_idx_ptr] = sample;
        buff_idx_ptr = (buff_idx_ptr++ & BUFFLEN);
    } while(1);

}

void audioHWI(void){

    s16 = read_audio_sample();
    SEM_post(&sem);
}

