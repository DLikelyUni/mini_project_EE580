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

#include "data_IIR.h"

#include <time.h>

#include <clk.h>

#define BIT0 0x01
#define BIT1 0x02
#define BIT2 0x04
#define BIT3 0x08
#define BIT4 0x10
#define BIT5 0x20
#define BIT6 0x40
#define BIT7 0x80

#define BUFFLEN  0x8000
#define IIR_A_LEN 16
#define IIR_B_LEN 32

#define REC_LOOPBACK BIT0
#define PLAYBACK_BUFF (BIT0 | BIT1)
#define MASK_PLAYBACK PLAYBACK_BUFF
#define LP_OUT BIT5
#define BP_OUT BIT6
#define HP_OUT BIT7
#define LP_BP_OUT (LP_OUT | BP_OUT)
#define LP_HP_OUT (LP_OUT | HP_OUT)
#define BP_HP_OUT (BP_OUT | HP_OUT)
#define LP_BP_HP_OUT (LP_OUT | BP_OUT | HP_OUT)
#define MASK_FILT LP_BP_HP_OUT

#undef CLOCKS_PER_SEC
#define CLOCKS_PER_SEC (300000000)
extern cregister volatile unsigned int TSCL;
extern cregister volatile unsigned int TSCH;

extern LOG_Obj trace;


int16_t sampBuffer[BUFFLEN] = {0};
volatile uint32_t buff_idx_ptr = 0;

int16_t iir_x_buff_16[IIR_A_LEN] = {0};
int16_t iir_x_buff_32[IIR_B_LEN] = {0};

float lp_y_buff[IIR_A_LEN] = {0};
float bp_y_buff[IIR_B_LEN] = {0};
float hp_y_buff[IIR_A_LEN] = {0};

uint8_t iir_idx_ptr_16 = 0;
uint8_t iir_idx_ptr_32 = 0;

float graph_vals[1024] = {0};

volatile int16_t s16;
volatile int16_t y16;
//clock_t start_t, end_t;
/*
 *  ======== main ========
 */

/*void dip_vals(uint32_t *playback_mode, uint32_t *filter_sel){
    uint32_t dip_status;
    DIP_getAll(&dip_status);
    *playback_mode = dip_status & MASK_PLAYBACK;
    *filter_sel = dip_status & MASK_FILT;
}*/
volatile uint32_t playback_mode = 0;
volatile uint32_t filter_sel = 0;

int vals_index = 0;

clock_t clock(){
    unsigned int low = TSCL;
    unsigned int high = TSCH;
    if (high) return (clock_t)-1;
    return low;
}

void main(void)
{
    LOG_printf(&trace, "hello world!");

    //BINTEN
    initAll();
    int i;
    for (i=0; i < 15; i++){
        a_lp[i] = a_lp[i] / 2;
        b_lp[i] = b_lp[i] / 2;
        a_hp[i] = a_hp[i] / 2;
        b_hp[i] = b_hp[i] / 2;
    }
    for (i=0; i < 31; i++){
            a_bp[i] = a_bp[i] / 2;
            b_bp[i] = b_bp[i] / 2;
    }

    //SWI_post(&SWI0);

    /* fall into DSP/BIOS idle loop */
    return;
}

// 20Hz LED toggle PRD
void loopbackLED(void){


    uint32_t dip_status;
    DIP_getAll(&dip_status);
    playback_mode = dip_status & MASK_PLAYBACK;
    filter_sel = dip_status & MASK_FILT;
    //dip_vals(&playback_mode, &filter_sel);

    switch (playback_mode){
    case REC_LOOPBACK:
        LED_toggle(LED_1);
        LED_toggle(LED_2);
        break;
    case 0:
        LED_turnOff(LED_1);
        LED_turnOff(LED_2);
        break;
    default:
        /* do nothing */
        break;
    }

}

// 6Hz LED toggle PRD
void filterLED(void){
    //uint32_t playback_mode, filter_sel;
    //uint32_t playback_mode;
    //uint32_t filter_sel;

    //dip_vals(&playback_mode, &filter_sel);

    if ( playback_mode == PLAYBACK_BUFF ){
    switch (filter_sel){
    case 0:
        LED_turnOff(LED_2);
        break;
    default:
        LED_toggle(LED_2);
        break;
    }
    } else {
        /* do nothing */
    }
    //
}

// 2Hz LED toggle PRD
void bufferLED(void){
    //uint32_t playback_mode;
    //uint32_t filter_sel;
    /*uint32_t dip_status;
    DIP_getAll(&dip_status);
    playback_mode = dip_status & MASK_PLAYBACK;
    filter_sel = dip_status & MASK_FILT;*/
    //uint32_t playback_mode, filter_sel;
    //dip_vals(&playback_mode, &filter_sel);

    if ( playback_mode == PLAYBACK_BUFF ){
        LED_toggle(LED_1);
        switch (filter_sel){
        case 0:
            LED_turnOff(LED_2);
            break;
        default:
            /* do nothing */
            break;
        }
    } else {
        /* do nothing */
    }

}

void getDIP(void){
    uint32_t dip_status;
    DIP_getAll(&dip_status);
    playback_mode = dip_status & MASK_PLAYBACK;
    filter_sel = dip_status & MASK_FILT;
}



static inline int16_t iir_filt(int16_t *iir_x_buff, float *iir_y_buff, uint8_t iir_idx_ptr, float *iir_a_coef, float *iir_b_coef, int filt_len){
    int i;
    uint8_t idx = iir_idx_ptr;
    float sum = 0;
    #pragma UNROLL(16)
    #pragma MUST_ITERATE(,,16)
    for(i = 0; i < filt_len; i++){
        sum += (float)iir_x_buff[idx]*iir_b_coef[i];
        sum += iir_y_buff[idx]*iir_a_coef[i];
        idx--;
        idx &= (filt_len-1);
    }
    return(sum);
}




void audioHWI(void){

    //volatile int16_t s16;
    //volatile int16_t s16;
    //volatile int16_t y16 = 0;

    s16 = read_audio_sample();
    //uint32_t playback_mode, filter_sel;
    //dip_vals(&playback_mode, &filter_sel);

    clock_t start_t, end_t;
    /*uint32_t playback_mode;
    uint32_t filter_sel;
    uint32_t dip_status;
    DIP_getAll(&dip_status);
    playback_mode = dip_status & MASK_PLAYBACK;
    filter_sel = dip_status & MASK_FILT;*/



    /*float y_lp = 0;
    float y_bp = 0;
    float y_hp = 0;*/



    if(MCASP->RSLOT){
        //SWI_post(&SWI0);

        switch (playback_mode){
                case REC_LOOPBACK:
                    sampBuffer[buff_idx_ptr] = s16;
                    y16 = s16;
                    break;
                case PLAYBACK_BUFF:
                    start_t = clock();


                    iir_x_buff_32[iir_idx_ptr_32] = sampBuffer[buff_idx_ptr];
                    iir_x_buff_16[iir_idx_ptr_16] = sampBuffer[buff_idx_ptr];
                    lp_y_buff[iir_idx_ptr_16] = iir_filt(iir_x_buff_16, lp_y_buff, iir_idx_ptr_16, a_lp, b_lp, N_LOWPASS_B);
                    bp_y_buff[iir_idx_ptr_32] = iir_filt(iir_x_buff_32, bp_y_buff, iir_idx_ptr_32, a_bp, b_bp, N_BANDPASS_B);
                    hp_y_buff[iir_idx_ptr_16] = iir_filt(iir_x_buff_16, hp_y_buff, iir_idx_ptr_16, a_hp, b_hp, N_HIGHPASS_B);

                    switch (filter_sel){
                    case LP_OUT:
                        y16 = (int16_t)lp_y_buff[iir_idx_ptr_16];
                        break;
                    case BP_OUT:
                        y16 = (int16_t)bp_y_buff[iir_idx_ptr_32];
                        break;
                    case LP_BP_OUT:
                        y16 = (int16_t)(lp_y_buff[iir_idx_ptr_16] + bp_y_buff[iir_idx_ptr_32]);
                        break;
                    case HP_OUT:
                        y16 = (int16_t)hp_y_buff[iir_idx_ptr_16];
                        break;
                    case LP_HP_OUT:
                        y16 = (int16_t)(lp_y_buff[iir_idx_ptr_16] + hp_y_buff[iir_idx_ptr_16]);
                        break;
                    case LP_BP_HP_OUT:
                        y16 = (int16_t)(lp_y_buff[iir_idx_ptr_16] + bp_y_buff[iir_idx_ptr_32] + hp_y_buff[iir_idx_ptr_16]);
                        break;
                    default:
                        y16 = sampBuffer[buff_idx_ptr];
                        graph_vals[vals_index] = y16;
                        vals_index++;
                        if (vals_index >= 1024){
                            vals_index = 0;
                        }

                        break;
                    }

                    iir_idx_ptr_32++;
                    iir_idx_ptr_32 &= (IIR_B_LEN-1);
                    iir_idx_ptr_16++;
                    iir_idx_ptr_16 &= (IIR_A_LEN-1);
                    end_t = clock();
                    LOG_printf(&trace, "Ticks: %d\n", (end_t - start_t));
                    //SWI_post(&SWI0);
                    break;
                default:
                    y16 = 0;
                    break;
                }
                buff_idx_ptr++;

                buff_idx_ptr &= (BUFFLEN-1);

    } else {
        y16 = 0;
        SWI_post(&SWI0);
        /*uint32_t dip_status;
        DIP_getAll(&dip_status);
        playback_mode = dip_status & MASK_PLAYBACK;
        filter_sel = dip_status & MASK_FILT;*/
    }


    write_audio_sample(y16);



}

