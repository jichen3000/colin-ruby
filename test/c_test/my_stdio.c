#include "stdio.h"
#include "ruby.h"
#define _XOPEN_SOURCE 600
#include <stdlib.h>

static VALUE rb_mStdio;
static VALUE rb_cStdioFile;

struct file
{
  FILE *fhandle;
  //int mode;			/* mode flags */
  //char *path;			/* pathname for file */
};

static void file_mark(struct file *f)
{
}

static void file_free(struct file *f)
{ 
  //if (f){
	//  fclose(f->fhandle);
	//  free(f);
  //}
}

static VALUE file_allocate(VALUE klass)
{
  struct file *f = malloc(sizeof(*f));
  f->fhandle = NULL;
  return Data_Wrap_Struct(klass, file_mark, file_free, f);
}

static VALUE 
file_open(object, fname, opt)
	VALUE object, fname, opt;
{
  struct file *f;
  Data_Get_Struct(object, struct file, f);
  f->fhandle = fopen(RSTRING(fname)->ptr, RSTRING(opt)->ptr);
  return Qnil;
}

static VALUE file_close(object)
	VALUE object;
{
  struct file *f;
  Data_Get_Struct(object, struct file, f);
  //if (f->fhandle)
  fclose(f->fhandle);
  return Qnil;
}

static VALUE file_readbyte(VALUE object)
{
  char buffer[2] = { 0, 0 };
  struct file *f;

  Data_Get_Struct(object, struct file, f);

  if (! f->fhandle)
    rb_raise(rb_eRuntimeError, "Attempt to read from closed file");

  fread(buffer, 1, 1, f->fhandle);

  return rb_str_new2(buffer);
}

static VALUE file_read(VALUE object, VALUE lcount)
{
  struct file *f;
	VALUE str;
	long len;
	len = NUM2LONG(lcount);
	str = rb_str_new(0, len);	
	  

  Data_Get_Struct(object, struct file, f);
  
  //printf("pre read pos: (%ld)",ftell(f->fhandle));
  ftell(f->fhandle); //如果不加入这个语句，会在seek之后出现读取的内容不对
  fread(RSTRING(str)->ptr, 1, len, f->fhandle);
  
  return str;
}

static VALUE
file_seek(object, offset, whence)
    VALUE object, offset, whence;
{
		struct file *f;
		long loffset;
		int iwhence;
		//long pos;
		long state;
		
		Data_Get_Struct(object, struct file, f);
		loffset = NUM2LONG(offset);
		iwhence = NUM2INT(whence);

    //printf("offset: (%ld); whence: (%d)  \n",loffset,iwhence);
    
    state = fseek(f->fhandle, loffset, iwhence);
    //pos = ftell(f->fhandle); //
    
    //if (pos < 0) rb_sys_fail(f->path);
    
    //return LONG2NUM(pos);
    return LONG2NUM(state);
}

static VALUE 
file_tell(object)
	VALUE object;
{
	struct file *f;
	long pos;
	
	Data_Get_Struct(object, struct file, f);
	
	pos = ftell(f->fhandle);
	
	return LONG2NUM(pos);
}

static VALUE 
file_write(object, str)
	VALUE object, str;
{
	struct file *f;
	long nread,offset;
	char *buffer;
	
	Data_Get_Struct(object, struct file, f);
	
	memset( &nread, 0, sizeof(long));
	
	posix_memalign(&buffer,512,RSTRING(str)->len);	
	memset( buffer, 0, RSTRING(str)->len) ;
	buffer = RSTRING(str)->ptr;
	offset = 0;
	
	printf("len: (%d), size: (%d) (%x),(%x),(%x) \n",RSTRING(str)->len,sizeof(RSTRING(str)->ptr[0]),RSTRING(str)->ptr[0],
			RSTRING(str)->ptr[1],RSTRING(str)->ptr[2]);
	printf("pos: %d\n",ftell(f->fhandle));
  //ftell(f->fhandle); 
	//nread = fwrite(RSTRING(str)->ptr, sizeof(RSTRING(str)->ptr[0]), RSTRING(str)->len, f->fhandle);
	//fflush(f->fhandle);
	nread = fwrite(buffer, sizeof(RSTRING(str)->ptr[0]), RSTRING(str)->len, f->fhandle);
	printf("pos: %d\n",ftell(f->fhandle));
	
	return LONG2FIX(nread);
}

void Init_my_stdio()
{
  rb_mStdio = rb_define_module("MyStdio");
  rb_cStdioFile = rb_define_class_under(rb_mStdio, "File", rb_cObject);

  rb_define_alloc_func(rb_cStdioFile, file_allocate);
  rb_define_method(rb_cStdioFile, "open", file_open, 2);
  rb_define_method(rb_cStdioFile, "close", file_close, 0);
  rb_define_method(rb_cStdioFile, "tell", file_tell, 0);
  rb_define_method(rb_cStdioFile, "readbyte", file_readbyte, 0);
  rb_define_method(rb_cStdioFile, "read", file_read, 1);
  rb_define_method(rb_cStdioFile, "seek", file_seek, 2);
  rb_define_method(rb_cStdioFile, "write", file_write, 1);
}



