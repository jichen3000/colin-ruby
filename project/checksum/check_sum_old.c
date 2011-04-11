#include "ruby.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>


static VALUE rb_module_checksum;
static VALUE rb_class_CheckBlock;
static VALUE do_checksum(class,blockSize,dataBuf)
       VALUE class,blockSize,dataBuf;
{
  //printf("okokokokokokok!");
  unsigned char *buffer;
  int block_size=NUM2INT(blockSize);
  memcpy(buffer, RSTRING(dataBuf)->ptr, block_size);
  unsigned char block1[16]="";
  unsigned char block2[16]="";
  unsigned char block3[16]="";
  unsigned char block4[16]="";
  unsigned char out1[16]="";
  unsigned char out2[16]="";
  unsigned char res[16]="";
  unsigned char nul[16]="";
  int count=0;
  unsigned int r0=0,r1=0,r2=0,r3=0,r4=0;
  while(count<block_size)
  {
    printf("%d\n",count);
	memmove(block1,&buffer[count],16);
    memmove(block2,&buffer[count+16],16);
    memmove(block3,&buffer[count+32],16);
    memmove(block4,&buffer[count+48],16);
    do_16_byte_xor(block1,block2,out1);
    do_16_byte_xor(block3,block4,out2);
    do_16_byte_xor(nul,out1,res);
    memmove(nul,res,16);
    do_16_byte_xor(nul,out2,res);
    memmove(nul,res,16);
    count=count+64;
  }
  memmove(&r1,&res[0],4);
  memmove(&r2,&res[4],4);
  memmove(&r3,&res[8],4);
  memmove(&r4,&res[12],4);

  r0=r0^r1;
  r0=r0^r2;
  r0=r0^r3;
  r0=r0^r4;
  
  r1=r0;
  r0=r0>>16;
  r0=r0^r1;
  r0=r0&0xFFFF;
  printf("okokokokokokok!");
  printf("%d",r0);
  return INT2NUM(r0);
}

int do_16_byte_xor(unsigned char *block1,unsigned char *block2,unsigned char *out)
{
  int c=0;
  while(c<16)
  {
    out[c]=block1[c]^block2[c];
    c++;
  }
  return 0;
}

void Init_checksum()
{
  rb_module_checksum = rb_define_module("CheckSum");
  rb_class_CheckBlock = rb_define_class_under(rb_module_checksum, "CheckBlock", rb_cObject);
  rb_define_module_function(rb_module_checksum,"do_checksum",do_checksum,2);
}