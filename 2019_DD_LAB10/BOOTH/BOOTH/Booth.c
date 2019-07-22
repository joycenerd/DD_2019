#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/mman.h>

#define ZYNQ_BASE		    0x80000000  //base address for 64 sequence of integer
#define CTRL_OFFSET 	    0x00000100  //for ctrl signal c
#define STATUS_OFFSET       0x00000104  //for status signal
#define ACCELERATOR         1           //use accelerator or not

#define DEPTH 8

#if ACCELERATOR==1      
#include <sys/mman.h>
#endif

#if ACCELERATOR==1
void Booth_Accelerator(int A[], long long result[]);
#endif

int main()
{
    int i, j;
    int A[DEPTH];
    int sw_result[DEPTH];
	long long hw_result[DEPTH];
	
	for(i=0;i<DEPTH;i++){
		if(i>4)
			A[i]=65536;
		else
			A[i]=-i-1;
		
		printf("inputdata[%02d] = %d\n", i, A[i]);
	}
	
#if ACCELERATOR==1	
	Booth_Accelerator(A,hw_result);
#endif

	for(i=0;i<DEPTH;i++){
		printf("accelerator result[%02d] = %lld\n", i,hw_result[i]);
	}
    
    return 0;
}

#if ACCELERATOR==1
void Booth_Accelerator(int A[], long long result[])
{
    int i;

    volatile int fd = open( "/dev/mem", O_RDWR);//volatile是一個變數聲明限定詞,可能會在任何時刻被意外的更新
    volatile int map_len = 0x400;
    volatile unsigned int* io = (volatile unsigned int *)mmap(NULL, map_len, PROT_READ | PROT_WRITE, MAP_SHARED, fd, ZYNQ_BASE);
	/*
	NULL :指向欲映射的核心起始位址,NULL代表讓系統自動選定位址
	map_len :代表映射的大小。將文件的多大長度映射到記憶體
	參數prot :映射區域的保護方式。可以為以下幾種方式的組合：
		PROT_EXEC 映射區域可被執行
		PROT_READ 映射區域可被讀取
		PROT_WRITE 映射區域可被寫入
		PROT_NONE 映射區域不能存取
	參數flags :影響映射區域的各種特性。在調用mmap()時必須要指定MAP_SHARED 或MAP_PRIVATE。
		MAP_SHARED 允許其他映射該文件的行程共享，對映射區域的寫入數據會複製回文件。
		MAP_PRIVATE 不允許其他映射該文件的行程共享，對映射區域的寫入操作會產生一個映射的複製(copy-on-write)，對此區域所做的修改不會寫回原文件。
	fd :要映射到核心中的文件
	ZYNQ_BASE :從文件映射開始處的偏移量
	*/

	if(io == MAP_FAILED)
    {
		perror("Mapping memory for absolute memory access failed.\n");
		exit(1);
	}
	printf("Zynq_BASE mapping successful :\n0x%x to 0x%x, size = %d\n", ZYNQ_BASE, (int)io, map_len);
	
    for(i = 0 ; i < DEPTH ; i++){
		*(io + i) = A[i];
		printf("start run\n");
		*(io+(CTRL_OFFSET>>2)) = 0x1;	// 001 reset the whole multiplier
		*(io+(CTRL_OFFSET>>2)) = 0x0;
		
		printf("polling busy\n");
		
		while ( *(io+(STATUS_OFFSET >> 2))==(volatile unsigned int)0)
		{
			printf("0x%x\n",*(io+(STATUS_OFFSET >> 2)));
		}
		
		printf("operation finish\n");
		
		*(io+(CTRL_OFFSET>>2)) = 0x2;	// 100 get top 32 bits of result
		*(io+(CTRL_OFFSET>>2)) = 0x0;
		
		result[i] = *(io+i);
		result[i] = result[i]<<32; // left shift 32 bits
		
		*(io+(CTRL_OFFSET>>2)) = 0x4;	// 010 get the lower 32 bits of result
		*(io+(CTRL_OFFSET>>2)) = 0x0;
		
		result[i] = result[i] + *(io+i);
	}
	 
	munmap((void *)io, map_len);//釋放指標io指向的記憶體空間，並設釋放的記憶體大小  
	close(fd);
}
#endif