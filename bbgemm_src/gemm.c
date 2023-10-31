/*
Implementation based on algorithm described in:
The cache performance and optimizations of blocked algorithms
M. D. Lam, E. E. Rothberg, and M. E. Wolf
ASPLOS 1991
*/

#include "gemm.h"


void bbgemm(TYPE m1[N], TYPE m2[N], TYPE prod[N] ,TYPE signal_mul[encore_buff],TYPE signal_temp_x[encore_buff],TYPE signal_m2[encore_buff]){
#pragma HLS INTERFACE ap_memory port=prod storage_type=ram_s2p latency=1
#pragma HLS INTERFACE ap_memory port=signal_mul storage_type=ram_1p latency=1
#pragma HLS INTERFACE ap_memory port=signal_temp_x storage_type=ram_1p latency=1
#pragma HLS INTERFACE ap_memory port=signal_m2 storage_type=ram_1p latency=1
//#pragma HLS INTERFACE  ap_vld port=signal_mul
//#pragma HLS INTERFACE  ap_vld port=signal_temp_x
//#pragma HLS INTERFACE  ap_vld port=signal_m2

    int i, k, j, jj, kk;
    int i_row, k_row;
    int encore_num = 0;
    TYPE mul,temp_x;
    loopjj:for (jj = 0; jj < row_size; jj += block_size){
        loopkk:for (kk = 0; kk < row_size; kk += block_size){
            loopi:for ( i = 0; i < row_size; ++i){
                loopk:for (k = 0; k < block_size; ++k){
                    i_row = i * row_size;
                    k_row = (k  + kk) * row_size;
                    temp_x = m1[i_row + k + kk];
                    loopj:for (j = 0; j < block_size; ++j){
                        mul = temp_x * m2[k_row + j + jj];
                        //Encore
                        signal_mul[encore_num] = mul;
                        signal_temp_x[encore_num] = temp_x;
                        signal_m2[encore_num] = m2[k_row + j + jj];
                        if(encore_num < encore_buff-1){
                        	encore_num ++;
                        }
                        else{
                        	encore_num = 0;
                        }
                        //encore_num = (encore_num + 1)%encore_buffs
                        //End
                        prod[i_row + j + jj] += mul;


                    }
                }
            }
        }
    }
}
