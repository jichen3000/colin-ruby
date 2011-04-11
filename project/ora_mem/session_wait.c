/* 
     Script:              session_wait.pc 
     Author:             Miladin Modrakovic 
     Dated:              May 2004                */ 
 
#include <stdio.h> 
#include <sys/ipc.h> 
#include <sys/shm.h> 
//#include <sqlca.h> 
//#include <errno.h> 
#include "events.h"  
#include <string.h> 


void *sga_attach (void *addr, int shmid) 
{ 
  if ( addr != 0 ) 
    addr=(void *)shmdt(addr); 
  addr=(void *)shmat(shmid,(void *)SGA_BASE,SHM_RDONLY); 
  if (addr  == (void *)-1) { 
    printf("shmat: error attatching to SGA\n"); 
    exit(1); 
  }  
  return addr; 
}

/*SetUp variables */ 
int main(int argc, char **argv) 
{ 
  void  *addr; 
  int   shmid[100]; 
  void  *sga_address; 
  int   shmaddr; 
  void  *current_addr; 
  long  p1r, p2r, p3r; 
  unsigned int i, sid, evn, wtm; 
  unsigned int   cur_time = 0; 
  int   seq; 
  int   seqs[SESSIONS]; 
  int   cmit_time=0; 
  int frequency=1;
  short r1;
 
 
  for(i=0;i<SESSIONS;i++){
    seqs[i]=0;
  } 
  if(argc != 2){ 
    fprintf(stderr, "Usage: %s shmid \n", *argv); 
    exit(1); 
  } 
  shmid[0]=atoi(argv[1]); 
  addr=0; 
  addr=sga_attach(addr,shmid[0]); 
      printf("addr:%x\n",(int)addr); 
 
  /* LOOP OVER ALL SESSIONS until CANCEL */ 
  while (1) { 
    //addr=sga_attach(addr,shmid[0]);
    /* set current address to beginning of Table */ 
    current_addr=(void *)KSUSECST_ADDR; 
    //current_addr=(void *)((int)addr+KSUSECST_ADDR); 
    printf("sid\t seq\t event\t p1\t p2\t p3\t secs\n");
      printf("current_addr:%x\n",(int)current_addr); 
      printf("current_addr:%d\n",(int)current_addr); 
      //printf("current:%x\n",*current_addr); 
      printf("KSUSECST_ADDR:%x\n",KSUSECST_ADDR); 
    for ( i=1; i < SESSIONS ; i++ ) {
      printf("mmmmm\n"); 
      seq=(unsigned short *)((int)current_addr+KSUSSSEQ); 
	  //r1= *seq;
      //printf("r1:%d\n",r1);
      evn=(short *)         ((int)current_addr+KSUSSOPC);
      //r1= *evn; 
      printf("evn:%d\n",evn);
      //printf("r1:%d\n",r1);
      printf("(int)current_addr+KSUSSOPC:%d\n",(int)current_addr+KSUSSOPC);
      p1r=(long *)          ((int)current_addr+KSUSSP1R); 
      p2r=(long *)          ((int)current_addr+KSUSSP2R);  
      p3r=(long *)          ((int)current_addr+KSUSSP3R); 
  //    wtm=*(int *)           ((int)current_addr+KSUSSTIM-4); 
  //    if ( wtm > cur_time )  
  //      cur_time=wtm;   
      if (evn != 0 ){
        //printf("sga$.session_wait");
//        printf("%u\t %u\t %u\t %d\t %d\t %d\t %u\n",i,seq, event[evn], p1r, p2r, p3r, cur_time - wtm);
        printf("%u\t %u\t %u\t %d\t %d\t %d\n",i,seq, event[evn], p1r, p2r, p3r);
        cmit_time++;
        if (cmit_time>1)
          exit(0);
      }
      current_addr=(void *)((int)current_addr+RECORD_SZ); 
    } 
    sleep(frequency); 
  } 
} 
