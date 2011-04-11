//#define _LARGEFILE64_SOURCE
//#define _FILE_OFFSET_BITS 64
#include "ruby.h"
#include <errno.h>
#include <sys/utsname.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>
#include <fcntl.h>
//#include <asm/fcntl.h>
//#define _XOPEN_SOURCE 600
#include <stdlib.h>
//#define FILE_MODE (S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH)

static VALUE rb_module_rawio;
static VALUE rb_class_rawfile;
VALUE rb_eRawIOError;

struct file
{
	int fhandle;
	int block_size; // system's block size
	int mode; // open mode
	off_t pos; // pointer pos
	char *path; // file path
};

static void
file_mark(f)
	struct file *f;
{
}

static void
file_free(f)
	struct file *f;
{
	close(f->fhandle);
	free(f);
}

static VALUE 
file_allocate(klass)
	VALUE klass;
{
  struct file *f = malloc(sizeof(*f));
	//memset( &f->fhandle, 0, sizeof(int) ) ;
  f->fhandle = 0;
  return Data_Wrap_Struct(klass, file_mark, file_free, f);
}

static VALUE 
test_rawfile(obj, fname)
	VALUE obj, fname;
{
	struct stat	S_stat ;

	if( lstat( RSTRING(fname)->ptr, &S_stat ) )
		//rb_warn("Get file(%s) stat error!!",RSTRING(fname)->ptr) ;
		rb_raise(rb_eRawIOError,"File(%s) is not exist!!",RSTRING(fname)->ptr);
	//printf("file size: %lld \n",S_stat.st_size);
	//printf("file st_mode: %s \n",S_stat.st_mode);
	//test is char device
	if( S_ISCHR(S_stat.st_mode) )
		return Qtrue;
	else
		return Qfalse;
}

static VALUE
test_exist(obj,fname)
	VALUE obj,fname;
{
	struct stat	S_stat ;

	if( stat( RSTRING(fname)->ptr, &S_stat ) ) return Qfalse;
  return Qtrue;
}
static int 
firstpos_chr(s1,s2)
	const char *s1;
	int s2;
{
	char * c;
	int result;
	result = -1;
	c = (char*)strchr(s1, s2);
	if (c!=NULL)
	  result = c-s1;
	
	return result;
}
static VALUE 
file_open(object, fname, opt)
	VALUE object, fname, opt;
{
  struct file *f;
	struct utsname	S_name ;
	int		iFlag ;
	if (RSTRING(opt)->len > 3)
		rb_raise(rb_eRawIOError,"Not support open mode(%s)!!",RSTRING(opt)->ptr);
	//exist?
	if (test_exist(object, fname)==Qfalse) 
		rb_raise(rb_eRawIOError,"File(%s) is not exist!!",RSTRING(fname)->ptr);
	 
  Data_Get_Struct(object, struct file, f);


	if(firstpos_chr(RSTRING(opt)->ptr, '+')>0)
		iFlag = O_RDWR;//2
	else if(firstpos_chr(RSTRING(opt)->ptr, 'w')>=0)
		iFlag = O_WRONLY ;//1
	else if(firstpos_chr(RSTRING(opt)->ptr, 'r')>=0 )
		iFlag = O_RDONLY ;//0
	else
		rb_raise(rb_eRawIOError,"Not support open mode(%s)!!",RSTRING(opt)->ptr);
/*	if(firstpos_chr(RSTRING(opt)->ptr, '+')>0)
		iFlag = O_RDWR|O_LARGEFILE;//2
	else if(firstpos_chr(RSTRING(opt)->ptr, 'w')>=0)
		iFlag = O_WRONLY|O_LARGEFILE ;//1
	else if(firstpos_chr(RSTRING(opt)->ptr, 'r')>=0 )
		iFlag = O_RDONLY|O_LARGEFILE ;//0
	else
		rb_raise(rb_eRawIOError,"Not support open mode(%s)!!",RSTRING(opt)->ptr);
	*/	
	f->fhandle = open(RSTRING(fname)->ptr, iFlag , 0644) ;
	f->pos = 0;
	f->mode = iFlag;
	f->path = RSTRING(fname)->ptr;
	f->block_size = 512;

	if( uname( &S_name ) == -1 )
		rb_raise(rb_eRawIOError,"Get system name error!!");
		
	if( !strncmp( S_name.sysname, "AIX", 3 ) )
	{
		lseek( f->fhandle, 512 * 8, SEEK_CUR ) ;
		f->pos = 512 * 8;
	}
	else if( !strncmp( S_name.sysname, "Linux", 5 ) )
		;
	else if( !strncmp( S_name.sysname, "HP", 2 ) )
		f->block_size = 1024;
	else if( !strncmp( S_name.sysname, "HP TRU64", 8 ) )
	{
		f->block_size = 1024;
		lseek( f->fhandle, 1024 * 64, SEEK_CUR ) ;
		f->pos = 1024 * 64;
	}
	else
		rb_raise(rb_eRawIOError,"Not support system(%s) error!!",S_name.sysname);
	
  return Qnil;
}

static VALUE 
file_close(object)
	VALUE object;
{
	struct file *f;
	Data_Get_Struct(object,struct file,f);
	f->pos = -1;
	f->mode = -1;
	f->block_size = -1;
	
	return Qnil; 
}

static VALUE 
get_pos(object)
	VALUE object;
{
	struct file *f;
	Data_Get_Struct(object,struct file,f);
	return OFFT2NUM(f->pos); 
}

static VALUE 
get_block_size(object)
	VALUE object;
{
	struct file *f;
	Data_Get_Struct(object,struct file,f);
	return INT2NUM(f->block_size); 
}

static VALUE
get_path(object)
	VALUE	object;
{
	struct file *f;
	Data_Get_Struct(object,struct file,f);
	return rb_tainted_str_new2(f->path);
}

static VALUE 
file_read(VALUE object, VALUE lcount)
{
  struct file *f;
	VALUE str;
	long len;
	long	 nread ;
	char buffer[8192];
	//char *buffer;
	
    //buffer = &buffer1[0];
	len = NUM2LONG(lcount);
	
  Data_Get_Struct(object, struct file, f);
  if (f->mode == O_WRONLY)
  	rb_raise(rb_eRawIOError,"Raw file not support read!!");
	if (len % f->block_size > 0)
  	rb_raise(rb_eRawIOError,"Read block size (%ld) must is %d multiple!!",
  			len,f->block_size);
	
	//posix_memalign(&(&buffer[0]),f->block_size, len);
	//memset( buffer, 0, len) ; 
  


	nread = read( f->fhandle, &buffer[0], len) ;
	str = rb_str_new(0, len);
	RSTRING(str)->ptr = &buffer[0];
		
  if (nread < 0)
		rb_raise(rb_eRawIOError,"Read raw file(%s) error!!",f->path);
		
  f->pos = f->pos + nread;
  //free(buffer);//must not add this line;
  return str;
}
static VALUE
file_seek(object, offset, whence)
  VALUE object, offset, whence;
{
	struct file *f;
	off_t loffset;
//	long loffset;
	int iwhence;
	off_t state;
	
//	memset( &loffset, 0, sizeof(off_t) ) ; 
	loffset = NUM2OFFT(offset);
	//printf("offset=%lld\n",loffset);
	iwhence = NUM2INT(whence);
	//support mode SEEK_SET 0,SEEK_CUR 1. seek_end 2 not support.
	if (iwhence > 1)
		rb_raise(rb_eRawIOError,"Not support seek mode(%d) error!!",iwhence);
	Data_Get_Struct(object, struct file, f);
	if (loffset % f->block_size > 0)
  	rb_raise(rb_eRawIOError,"Seek block size (%ld) must is %d multiple!!",
  			loffset,f->block_size);

  
  state = lseek(f->fhandle, loffset, iwhence);
	//printf("offset=%lld\n",loffset);
  
  if (state < 0) 
		rb_raise(rb_eRawIOError,"Seek raw file(%s) error!!",f->path);
		
	if (iwhence = 1)
		f->pos = f->pos + loffset;
	else
	  f->pos = loffset;
  
  return OFFT2NUM(state);
}

static VALUE 
file_write(object, str)
	VALUE object, str;
{
	struct file *f;
	long nread;
	char *buffer;

	  
	Data_Get_Struct(object, struct file, f);
	
  if (f->mode == O_RDONLY)
  	rb_raise(rb_eRawIOError,"Raw file not support write!!");
	if (RSTRING(str)->len % f->block_size > 0)
  	rb_raise(rb_eRawIOError,"Write block size (%ld) must is %d multiple!!",
  			RSTRING(str)->len,f->block_size);
  	
	posix_memalign(&buffer,f->block_size, RSTRING(str)->len);
	memset( buffer, 0, RSTRING(str)->len ) ; 
  strcpy( buffer, RSTRING(str)->ptr ) ;
	
//	printf("len: %d \n",RSTRING(str)->len);
	/*int i;	
	//printf("buffer: \n");
	//for (i=0;i<RSTRING(str)->len;i++)
	//	printf("%02X",buffer[i]);
	//printf("buffer end: \n");*/
	nread = write( f->fhandle, buffer, RSTRING(str)->len ) ;
	if( nread < 0 )
		rb_raise(rb_eRawIOError,"Write raw file(%s) error!!",f->path);
		
	free(buffer);
  f->pos = f->pos + nread;
	return LONG2FIX(nread);
}

void Init_rawio()
{
	rb_module_rawio = rb_define_module("RawIO");
	rb_class_rawfile = rb_define_class_under(rb_module_rawio,"RawFile",rb_cObject);
  rb_eRawIOError = rb_define_class("RawIOError", rb_eIOError);
	
	rb_define_module_function(rb_module_rawio,"rawfile?",test_rawfile,1);
	rb_define_module_function(rb_module_rawio,"exist?",test_exist,1);
	
  rb_define_alloc_func(rb_class_rawfile, file_allocate);
  rb_define_method(rb_class_rawfile, "open", file_open, 2);
  rb_define_method(rb_class_rawfile, "close", file_close, 0);
  rb_define_method(rb_class_rawfile, "read", file_read, 1);
  rb_define_method(rb_class_rawfile, "seek", file_seek, 2);
  rb_define_method(rb_class_rawfile, "write", file_write, 1);
  rb_define_method(rb_class_rawfile, "pos", get_pos, 0);
  rb_define_method(rb_class_rawfile, "tell", get_pos, 0);
  rb_define_method(rb_class_rawfile, "block_size", get_block_size, 0);
  rb_define_method(rb_class_rawfile, "path", get_path, 0);
	
	
}
