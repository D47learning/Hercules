/*
Implementation based on algorithm described in:
The cache performance and optimizations of blocked algorithms
M. D. Lam, E. E. Rothberg, and M. E. Wolf
ASPLOS 1991
*/

#include <stdio.h>
#include <stdlib.h>
#include "../../common/support.h"

#define encore_buff 64


//Data Type
//typedef ap_int<128> TYPE;
#define TYPE double

//Algorithm Parameters
#define row_size 64
#define col_size 64
#define N row_size*col_size
#define block_size 8
#define NUMOFBLOCKS N/block_size/block_size

//Define the input range to operate over
#define MIN 0.
#define MAX 1.0

//Set number of iterations to execute
#define MAX_ITERATION 1

void bbgemm(TYPE m1[N], TYPE m2[N], TYPE prod[N],TYPE signal_mul[encore_buff],TYPE signal_temp_x[encore_buff],TYPE signal_m2[encore_buff]);

////////////////////////////////////////////////////////////////////////////////
// Test harness interface code.

struct bench_args_t {
  TYPE m1[N];
  TYPE m2[N];
  TYPE prod[N];
  TYPE signal_mul[encore_buff];
  TYPE signal_temp_x[encore_buff];
  TYPE signal_m2[encore_buff];
};
