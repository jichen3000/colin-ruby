#include <stdio.h>
int do_ture(int block_size, unsigned char *buffer)
{
  unsigned char block[2]=""; 
  unsigned char out[2]=""; 
  unsigned char res[2]="";
  int count = 0;
  while(count < block_size)
  {
    memmove(block,&buffer[count],2); 
  printf("block-");
  print_buffer(2,block);
    do_2_byte_xor(block,out,res);    
  printf("out-");
  print_buffer(2,out);
  printf("res-");
  print_buffer(2,res);
    memmove(out,res,2); 
    count = count + 2;
  } 
  printf("%02X %02X \n",res[0],res[1]);
  return 1;
}
int do_2_byte_xor(unsigned char *block1, unsigned char *block2, unsigned char *out) 
{ 
  int c = 0; 
 
  while (c<2) 
  { 
    out[c] = block1[c] ^ block2[c]; 
    c ++; 
  } 
  return 0; 
} 
int do_checksum(int block_size, unsigned char *buffer) 
{ 
  unsigned char block1[16]=""; 
  unsigned char block2[16]=""; 
  unsigned char block3[16]=""; 
  unsigned char block4[16]=""; 
  unsigned char out1[16]=""; 
  unsigned char out2[16]=""; 
  unsigned char res[16]=""; 
  unsigned char nul[16]=""; 
  int count = 0; 
  unsigned int r0=0,r1=0,r2=0,r3=0,r4=0;
   
  while(count < block_size) 
  { 
  printf("index(%d) start\n",count);
    memmove(block1,&buffer[count],16); 
  printf("block1-");
  print_buffer(16,block1);
    memmove(block2,&buffer[count+16],16); 
  printf("block2-");
  print_buffer(16,block2);
    memmove(block3,&buffer[count+32],16); 
  printf("block3-");
  print_buffer(16,block3);
    memmove(block4,&buffer[count+48],16); 
  printf("block4-");
  print_buffer(16,block4);
    do_16_byte_xor(block1,block3,out1); 
  printf("out1-");
  print_buffer(16,out1);
    do_16_byte_xor(block2,block4,out2); 
  printf("out2-");
  print_buffer(16,out2);
    do_16_byte_xor(nul,out1,res); 
  printf("res1-");
  print_buffer(16,res);
    memmove(nul,res,16); 
    do_16_byte_xor(nul,out2,res); 
  printf("res2-");
  print_buffer(16,res);
    memmove(nul,res,16);
     
  printf("index(%d) end\n",count);
    count = count + 64; 
  } 
  printf("res-");
  print_buffer(16,res);
  memmove(&r1,&res[0],4); 
  memmove(&r2,&res[4],4); 
  memmove(&r3,&res[8],4); 
  memmove(&r4,&res[12],4); 
 
  printf("r1:%X\n",r1);
  printf("r2:%X\n",r2);
  printf("r3:%X\n",r3);
  printf("r4:%X\n",r4);
  printf("r0:%X\n",r0);
  r0 = r0 ^ r1; 
  printf("r0(r1):%X\n",r0);
  r0 = r0 ^ r2; 
  printf("r0(r2):%X\n",r0);
  r0 = r0 ^ r3;
  printf("r0(r3):%X\n",r0);
  r0 = r0 ^ r4; 
  printf("r0(r4):%X\n",r0);
  
  r1 = r0; 
  r0 = r0 >> 16; 
  printf("r0(r0 >> 16):%X\n",r0);
  r0 = r0 ^ r1; 
  printf("r1(r0 ^ r1):%X\n",r1);
  printf("r0(r0 ^ r1):%X\n",r0);
  r0 = r0 & 0xFFFF; 
  printf("r0(r0 & 0xFFFF):%X\n",r0);
 
  return r0; 
} 

int do_16_byte_xor(unsigned char *block1, unsigned char *block2, unsigned char *out) 
{ 
  int c = 0; 
 
  while (c<16) 
  { 
    out[c] = block1[c] ^ block2[c]; 
    c ++; 
  } 
  return 0; 
} 

void print_buffer(int block_size, unsigned char *buffer)
{
  int i;
  printf("buffer:\n");
  for(i=0; i<block_size; i++)
  {
    printf("%02X ",buffer[i]);
    if(((i+1)%16)==0 && i>0)
      printf("\n");
  }
}

main(int argc, char *argv[])
{
  FILE *fp;
  int block_number=1;
  int block_size=512;
  int nread;
  int check_sum=-1;
  unsigned char *buffer;
  
  printf("argc:%d\n",argc);
  printf("file name:%s\n",argv[1]);
  fp=fopen(argv[1],"r");
  
  if(argc>2)
    block_number=atoi(argv[2]);
  if(argc>3)
    block_size=atoi(argv[3]);
  printf("block_number:%d\n",block_number);
  printf("block_size:%d\n",block_size);
  
  //seek
  nread=fseek(fp,block_size*block_number,SEEK_CUR);
  if (nread < 0)
    fprintf(nread, "Seek file(%s) error!!\n",argv[1]);
  
  posix_memalign(&buffer,block_size, block_size);
  memset(buffer,0,block_size);
  
  nread=fread(buffer,block_size,1,fp);
  if (nread < 0)
    fprintf(stderr, "Read file(%s) error!!\n",argv[1]);
    
  print_buffer(block_size,buffer);
  printf("pre_check_sum:%02X %02X \n",buffer[14],buffer[15]);
  buffer[14]=0;
  buffer[15]=0;
  printf("%02X %02X \n",buffer[14],buffer[15]);
  
//  check_sum=do_checksum(block_size,buffer);
//  printf("cur_check_sum:%04X\n",check_sum);
  do_ture(block_size,buffer);
    
  
  free(buffer);
  fclose(fp);
} 
