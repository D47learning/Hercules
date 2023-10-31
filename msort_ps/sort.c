#include <stdio.h>
#include <stdlib.h>
#include <math.h>


#define SIZE 2048
#define TYPE int32_t
#define TYPE_MAX INT32_MAX

void ms_mergesort(TYPE a[SIZE]);
//*************HardWare Difftest block begin
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
    int32_t number;
    int32_t address;
}data;

struct data test;
uint64_t temp_regsum;
int counter=0;

void* create_map(size_t size, int fd, off_t offset) {
  void *base = mmap(NULL, size, PROT_READ|PROT_WRITE, MAP_SHARED, fd, offset);

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





//************Hardware Difftest block end
void merge(TYPE a[SIZE], int start, int m, int stop){
    TYPE temp[SIZE];
    int i, j, k;

    merge_label1 : for(i=start; i<=m; i++){
        temp[i] = a[i];
    }

    merge_label2 : for(j=m+1; j<=stop; j++){
        temp[m+1+stop-j] = a[j];
    }

    i = start;
    j = stop;

    merge_label3 : for(k=start; k<=stop; k++){
        TYPE tmp_j = temp[j];
        TYPE tmp_i = temp[i];
        if(tmp_j < tmp_i) {
            a[k] = tmp_j;
            test.address = k;
            test.number = tmp_j;
            if(counter<10){
                printf("%d,%d\n",test.address,test.number);
                counter++;
            }
            *(data*)(hdft_base)=test;
            j--;
        } else {
            a[k] = tmp_i;
            test.address = k;
            test.number = tmp_i;
            if(counter<10){
                printf("%d,%d\n",test.address,test.number);
                counter++;
            }
            *(data*)(hdft_base)=test;
            i++;
        }
    }
}

void ms_mergesort(TYPE a[SIZE]) {
    int start, stop;
    int i, m, from, mid, to;

    start = 0;
    stop = SIZE;

    mergesort_label1 : for(m=1; m<stop-start; m+=m) {
        mergesort_label2 : for(i=start; i<stop; i+=m+m) {
            from = i;
            mid = i+m-1;
            to = i+m+m-1;
            if(to < stop){
                merge(a, from, mid, to);
            }
            else{
                merge(a, from, mid, stop);
            }
        }
    }
}

int main(){
    TYPE a[SIZE];
    FILE* fp=fopen("input.data","r");
    for(int i=0;i<SIZE;i++){
        fscanf(fp,"%d\n",&(a[i]));
    }
    fclose(fp);
    init_map();

    long run_time;
	struct timeval time_start,time_over;	//开始时间
    gettimeofday(&time_start,NULL);	//计时开始


    ms_mergesort(a);

    gettimeofday(&time_over,NULL);	//计时结束
	  run_time=1000000*(time_over.tv_sec-time_start.tv_sec)+time_over.tv_usec-time_start.tv_usec;
    printf("******SORT_MERGE******\n");
    printf("A blocked version of matrix multiplication, with better locality.\n");
    printf("SIZE: %d\n",SIZE);
    printf("Use cpu : %f ms\n",(double)run_time/1000);



    
    finish_map();
    return 0;
}