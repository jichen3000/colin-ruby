#include "ruby.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>


static VALUE rb_module_checksum;
static VALUE rb_class_CheckBlock;

int do_xor(unsigned char *block, int block_size, unsigned char *res)
{
  unsigned char block_16[16]="";
  int i,j;
  int count_16 = block_size/16;
  for(i=0; i<count_16; i++){
    for(j=0;j<16;j++){
      block_16[j] = block_16[j] ^ block[16*i+j];
    }
  }
  for(i=0; i<8; i++){
    res[0] = res[0] ^ block_16[2*i+0];
    res[1] = res[1] ^ block_16[2*i+1];
  }
  return 0;
}
int do_xor32(unsigned char *block, int block_size, unsigned char *res)
{
  unsigned char block_16[64]="";
  int i,j;
  int count_16 = block_size/64;
  for(i=0; i<count_16; i++){
    for(j=0;j<64;j++){
      block_16[j] = block_16[j] ^ block[16*i+j];
    }
  }
  for(i=0; i<8; i++){
    res[0] = res[0] ^ block_16[2*i+0];
    res[1] = res[1] ^ block_16[2*i+1];
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


static VALUE do_checksum(class,dataBuf)
       VALUE class,dataBuf;
{
  unsigned char result[2];
  do_xor32(RSTRING(dataBuf)->ptr,RSTRING(dataBuf)->len,result);
  return rb_tainted_str_new(result,2);
}

void Init_checksum()
{
  rb_module_checksum = rb_define_module("CheckSum");
  rb_class_CheckBlock = rb_define_class_under(rb_module_checksum, "CheckBlock", rb_cObject);
  rb_define_module_function(rb_module_checksum,"do_checksum",do_checksum,1);
}
