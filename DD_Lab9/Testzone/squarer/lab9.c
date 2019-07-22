#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <unistd.h>

#define ZYNQ_BASE			  0x80000000  //base address for 64 sequence of integer
#define START_RUN_OFFSET      0x00000100  //for start signal
#define STATUS_OFFSET         0x00000104  //for status signal

/*===========================================================================*/
int main(int argc, char *argv[])
{
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
	int i,j;
	int m[64];
    int outm[64];	
 //   int cnt;
	
	if(io == MAP_FAILED) {
		perror("Mapping memory for absolute memory access failed.\n");
		exit(1);
	}
	printf("Zynq_BASE mapping successful :\n0x%x to 0x%x, size = %d\n", ZYNQ_BASE, (int)io, map_len);
	
/*
    for (i=5;i<64;i++){
       m[i] = 0 ;
  }
*/  
	m[0] = 0x3f000000;//0.5
    m[1] = 0x3e99999a;//0.3
    m[2] = 0x3e800000;//0.25
    m[3] = 0x3f4ccccd;//0.8
    m[4] = 0x3f19999a;//0.6
    m[5] = 0x3fc00000;//1.5
    m[6] = 0x3fa00000;//1.25
    m[7] = 0x3f400000;//0.75
    m[8] = 0x40600000;//3.5
    m[9] = 0x40900000;//4.5
    m[10] = 0x41200000;//10
    m[11] = 0x40280000;//2.625
    m[12] = 0x3fe00000;//1.75
    m[13] = 0x40f80000;//7.75
    m[14] = 0x41b20000;//22.25
    m[15] = 0x410c0000;//1.75

	printf("Original values:\n");
	for (i=0;i<16;i++){
		printf("Input %2d = %32x \n",i,m[i]);
//		if(i%4==3) putchar(10);
	}
    printf("// -----------------------------Running!-------------------------------------//\n");
    for (i=0;i<16;i++)
		*(io+i) = m[i];

    for (i=0;i<16;i++)
		m[i] = *(io+i);
/*   
	printf("Values before caculation:\n");
    
    for (i=0;i<16;i++){
		printf("%32x ",m[i]);
		if(i%4==3) putchar(10);
	}
*/
    printf("start run\n");
    // -------------------------------------------------------------------------
    //  start run
    // -------------------------------------------------------------------------
    *(io+(START_RUN_OFFSET/4)) = 1;
    *(io+(START_RUN_OFFSET/4)) = 0;

    printf("polling busy\n");
    // -------------------------------------------------------------------------
    //  polling busy
    // -------------------------------------------------------------------------
    while ( *(io+(STATUS_OFFSET/4))!=(volatile unsigned int)0){
    	printf("0x%x\n",*(io+(STATUS_OFFSET/4)));
	}
    printf("operation finish\n");


    for (i=0;i<64;i++)
		outm[i] = *(io+i);
    printf("// ------------------------------Finish!-------------------------------------//\n");
	printf("Values after caculation:\n");
    for (i=1;i<17;i++){
		printf("answer %2d = %32x \n",i-1,outm[i]);
	//	if(i%4==3) putchar(10);
	}
		
	munmap((void *)io, map_len);//釋放指標io指向的記憶體空間，並設釋放的記憶體大小  
	close(fd);
    return 0;
}
/*===========================================================================*/
