/*

     Script:         xksuse.c
     Author:         Kyle Hailey
     Dated:          June 2002
     Purpose:        read x$ksuse direclty  from the SGA
     copyright (c) 2002 Kyle Hailey
                v$session,
                v$sesstat
                v$session_wait

        runs the equivalent to

        set linesize 100
        set pagesize 40
	column event format A20
	column sid format 999
	column cpu format 99999
	column seq format 99999
	column ctime format 99999
        select
                w.sid    sid,
                w.seq#   seq,
                w.event  event,
                w.p1raw  p1,
                w.p2raw  p2,
                w.p3raw  p3,
                w.SECONDS_IN_WAIT  ctime,
                s.sql_hash_value sqlhash,
                s.prev_hash_value psqlhash,
                st.value cpu
       from
                v$session s,
                v$sesstat st,
                v$statname sn,
                v$session_wait w
       where
                w.sid = s.sid and
                st.sid = s.sid and
                st.statistic# = sn.statistic# and 
		sn.name = 'CPU used when call started' and
		w.event != 'SQL*Net message from client' 
       order by w.sid;

	#  create the file xksuse.h
	sqlplus "sys/sys as sysdbas" @xksuse
	#  compile 
	cc -o xksuse xksuse.c
  	# gets the shared memory segment id
  	# if this doesn't return a value, you'll have to
	# get the id on your own, either from ipcs -a
	# or from oradebug ipc
	sgaid.sh
        # run 
	./xksuse `sgaid.sh`

*/

 #include <stdio.h>
 #include <sys/ipc.h>
 #include <sys/shm.h>
 #include <errno.h>
 #include "xksuse.h"


 #define FORMAT1 "%4s %6s %-20.20s %10s %10.10s %10s %6s %4s %10s %10s %10s %10s\n"
 #define FORMAT2 "%4d %6d %-20.20s %10X %10.10X %10X %6u %4d %10d %10d %10u %10u\n"
 #define FORMAT3 "%4d %6d %-20.20s %10X %10.10s %10X %6u %4d %10d %10d %10u %10u\n"

void *sga_attach (void *addr, int shmid)
{

     if ( addr != 0 ) addr=(void *)shmdt(addr);
     addr=(void *)shmat(shmid,(void *)SGA_BASE,SHM_RDONLY);
     if (addr  == (void *)-1) {
         printf("shmat: error attatching to SGA\n");
         exit(1);
     } else {
        printf("address %lx %lu\n",(int *)addr,(long *)addr);
     }
     return addr;
}

 main(argc, argv)
 int argc;
 char **argv;
 {
  void  *addr;
  int   shmid[100];
  void  *sga_address;
  int   seqs[PROCESSES];
  long  p1r, p2r, p3r, psqla,sqla;
  unsigned int   cpu,i, tim, sid, uflg, flg, evn,  psqlh, sqlh, wtm,ctm,stm,ltm ;
  unsigned int   cur_time = 0;
  int   seq;
     for (i=0;i<PROCESSES;i++) { seqs[i]=0; }
     if (argc != 2) {
         fprintf(stderr, "Usage: %s shmid \n", *argv);
         exit(1);
     }
     shmid[0]=atoi(argv[1]);
     addr=0;
     addr=sga_attach(addr,shmid[0]);

    while (1) {
        addr=sga_attach(addr,shmid[0]);
        sga_address=(void *)START;
        sleep(1); 
        printf("[H [J");
        printf(FORMAT1,
              "sid", 
             "seq#",
             "wait",
               "p1",
               "p2",
               "p3",
               "cpu",
               "uflg",
               "stm",
               "wtm",
               "sqlh",
               "psqlh");
        printf("procs %i\n",PROCESSES);
        for ( i=0; i < PROCESSES ; i++ ) {
           sga_address=(void *)((int)users[i]);
           seq=*(unsigned short *)((int)sga_address+KSUSSSEQ);
           evn=*(short *)((int)sga_address+KSUSSOPC);
           p1r=*(long *)((int)sga_address+KSUSSP1R);
           p2r=*(long *)((int)sga_address+KSUSSP2R);
           p3r=*(long *)((int)sga_address+KSUSSP3R);
           tim=*(int   *)((int)sga_address+KSUSSTIM);
           sid=*(short *)((int)sga_address+KSUSENUM);
/*
           uflg=*(short *)(((int)sga_address));
           uflg=*(int   *)((int)sga_address+KSUSEFLG);
*/
#ifdef __linux
          uflg=*(short *)((int)sga_address)>>8;
#else
          uflg=*(short *)((int)sga_address);
#endif

           flg=*(int   *)((int)sga_address+KSUSEFLG);
           stm=*(int *)((int)sga_address+KSUSSTIM); 
           ltm=*(int *)((int)sga_address+KSUSELTM); 
           ctm=*(int *)((int)sga_address+KSUSELTM-8); 
           wtm=*(int *)((int)sga_address+KSUSELTM-4); 
           psqla=*(long *)((int)sga_address+KSUSEPSQ);
           sqla=*(long *)((int)sga_address+KSUSESQL);
           sqlh=*(int   *)((int)sga_address+KSUSESQH) ;
           psqlh=*(int   *)((int)sga_address+KSUSEPHA) ;
           cpu=*(int   *)((int)sga_address+CPU_USED_WHEN_CALL_STARTED) ;

           if ( wtm > cur_time )  cur_time=wtm; 
           if ( seqs[i] != seq  || 1 == 1) {
              if (  strcmp(event[evn],"SQL*Net message from client")  ) {
                  if ( flg%2 == 1 && uflg%2 == 1 ) {
                    if (  ! strcmp(event[evn],"latch free") ) {
                      printf(FORMAT3,
                        sid,
                        seq,
                        event[evn] ,
                        p1r,
                        latch[p2r],
                        p3r,
                        cpu,
                        uflg,
                        stm,
                        (cur_time - wtm ),
                        sqlh,
                        psqlh
                      );
                    } else {
                      printf(FORMAT2,
                        sid,
                        seq,
                        event[evn] ,
                        p1r,
                        p2r,
                        p3r,
                        cpu,
                        uflg,
                        stm,
                        (cur_time - wtm ),
                        sqlh,
                        psqlh
                      );
                    }
                  }
                }
           }
           seqs[i]=seq;
       }
   }
 }
