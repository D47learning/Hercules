/*
Implementation based on algorithm described in:
The cache performance and optimizations of blocked algorithms
M. D. Lam, E. E. Rothberg, and M. E. Wolf
ASPLOS 1991
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <memory.h>
#include <unistd.h>
#include <sys/mman.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <elf.h>
#include <inttypes.h>

#include <assert.h>
#include <sys/time.h>
#include <time.h>

//Data Type



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

void bbgemm(TYPE m1[N], TYPE m2[N], TYPE prod[N]);
////////////////////////////////////////////////////////////////////////////////
// Test harness interface code.

struct bench_args_t {
  TYPE m1[N];
  TYPE m2[N];
  TYPE prod[N];
};


//*************HardWare Difftest block begin


//#define CONFIG_ENABLE_INSTR_CNT y
volatile void *hdft_base;
#define KiB *1024UL
#define MiB *1024*1024UL
#define GiB *1024*1024*1024UL
#define HDFT_SIZE 1
#define HDFT_BASE 0xA0000000
size_t N_interate = 10 MiB;
int fd;
typedef struct data{   
    uint64_t number;
    uint64_t address;
}data;

struct data test;
int counter=0;

void* create_map(size_t size, int fd, off_t offset) {
  void* base = mmap(NULL, size, PROT_READ|PROT_WRITE, MAP_SHARED, fd, offset);

  if (base == MAP_FAILED) {
    perror("init_mem mmap failed:");
    close(fd);
    exit(1);
  }

  printf("mapping paddr 0x%lx to vaddr 0x%" PRIxPTR "\n", offset, (uintptr_t)base);

  return base;
}

void init_map() {
  fd = open("/dev/mem", O_RDWR|O_SYNC);
  if (fd == -1)  {
    perror("init_map open failed:");
    exit(1);
  }

  hdft_base = create_map(HDFT_SIZE, fd, HDFT_BASE);
}

void finish_map() {
  munmap((void *)hdft_base, HDFT_SIZE);
  close(fd);
}

uint64_t fold_xor_g1(uint64_t *str, uint32_t len) //输入为64bit数据的数组，然后还有数组的个数(16)
{
	uint64_t result_tmp=0;
	uint64_t data=0;
	int i=0;
	uint64_t result_64=0;
	
	while(len--)
	{
		i+=1; 
		data=(*str++);
		result_tmp = (data ^ (data<<32));						//第一次折叠异或
		result_tmp ^= (result_tmp<<16);							//第二次折叠异或
		result_tmp ^= (result_tmp<<8);							//第三次折叠异或
		result_64  += (result_tmp&0xff00000000000000)>>(8*(i-1));		
	}
	
	return result_64;
}




void bbgemm(TYPE m1[N], TYPE m2[N], TYPE prod[N]){
    int i, k, j, jj, kk;
    int i_row, k_row;
    uint64_t* temp;
    uint64_t dut_data[8];
    uint64_t compress_out;
    TYPE temp_x, mul;

    loopjj:for (jj = 0; jj < row_size; jj += block_size){
        loopkk:for (kk = 0; kk < row_size; kk += block_size){
            loopi:for ( i = 0; i < row_size; ++i){
                loopk:for (k = 0; k < block_size; ++k){
                    i_row = i * row_size;
                    k_row = (k  + kk) * row_size;
                    temp_x = m1[i_row + k + kk];
                    loopj:for (j = 0; j < block_size; ++j){
                        mul = temp_x * m2[k_row + j + jj];
                        temp = &m2[k_row + j + jj];
                        dut_data[2] = *temp;
                        temp = &temp_x;
                        dut_data[3] = 0;
                        dut_data[4] = *temp;
                        temp = &mul;
                        dut_data[5] = 0;
                        dut_data[6] = *temp;
                        dut_data[7] = 0;
                        prod[i_row + j + jj] += mul;
                        temp = &prod[i_row + j + jj];
                        dut_data[0] = *temp;
                        dut_data[1] = 0;
                        compress_out = fold_xor_g1(dut_data,8);
                        test.address = i_row + j + jj;
                        test.number = compress_out;
                        
                        *(data*)(hdft_base)=test;
                        counter++;

                    }
                }
            }
        }
    }
}


int main(){
    TYPE m1[N];
    TYPE m2[N];
    TYPE prod[N]={0};
    FILE* fp=fopen("input.data","r");
    for(int i=0;i<N;i++){
        fscanf(fp,"%lf\n",&(m1[i]));
    }
    for(int j=0;j<N;j++){
        fscanf(fp,"%lf\n",&(m2[j]));
    }
    fclose(fp);
    init_map();

    long run_time;
	  struct timeval time_start,time_over;	//开始时间
    gettimeofday(&time_start,NULL);	//计时开始
    
    bbgemm(m1,m2,prod);
    
    gettimeofday(&time_over,NULL);	//计时结束
	  run_time=1000000*(time_over.tv_sec-time_start.tv_sec)+time_over.tv_usec-time_start.tv_usec;
    printf("Use a blocked version of matrix multiplication\n");
    printf("Matrix Size: %d* %d, Matrix Data Type: double, Block Size: %d\n",row_size,col_size,block_size);
    printf("Use cpu : %f ms\n",(double)run_time/1000);

    finish_map();
    
    return 0;
}
