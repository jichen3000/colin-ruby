#include <stdio.h>
#include <errno.h>
#include <sys/utsname.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>
#include <fcntl.h>
#define _XOPEN_SOURCE 600
#include <stdlib.h>

#define	TRUE	1
#define	FALSE	0 

/*
 *  FUNCTION NAME:  israw()
 *  FUNCTION    :   判断是否为裸设备
 *  INPUT       :   char *sFile		裸设备文件名
 *  OUTPUT      :   -1          ERROR
 *					0			FALSE
 *                  1           TRUE
 */
int israw( char *sFile )
{
	struct stat	S_stat ;
	
	memset( &S_stat, 0, sizeof(struct stat) ) ;

	if( stat( sFile, &S_stat ) )
		return -1 ;

	if( S_ISCHR(S_stat.st_mode) )
		return TRUE ;
	else
		return FALSE ;
}

/*
 *  FUNCTION NAME:  rawopen()
 *  FUNCTION    :   打开裸设备
 *  INPUT       :   char *sFile		裸设备文件名
 *					int  *fd		文件描述符,打开设备后带回
 *					char *sOpt		操作类型: "r" 读, "w" 写, "rw" 读写
 *  OUTPUT      :   系统错误码,详细信息请对照/usr/include/sys/errno.h
 */
int rawopen( char *sFile, int *fd, char *sOpt )
{
	struct utsname	S_name ;
	int		iFlag ;

	memset( &S_name, 0, sizeof(struct utsname) ) ;
	memset( &iFlag, 0, sizeof(int) ) ;

	if( !strcmp( sOpt, "r" ) )
		iFlag = O_RDONLY ;
	else if( !strcmp( sOpt, "w" ) )
		iFlag = O_WRONLY ;
	else if( !strcmp( sOpt, "rw" ) )
		iFlag = O_RDWR ;
	else
		return -1 ;

	*fd = open( sFile, iFlag ) ;
	if( *fd < 0 )
	{
		fprintf( stderr, "打开裸设备出错[%s][%d][%s]\n", 
							sFile, errno, strerror(errno) ) ;
		return(errno) ;
	}

	/* 判断是什么操作系统 */
	if( uname( &S_name ) == -1 )
	{
		fprintf( stderr, 
				"取操作系统信息出错[%d][%s]\n", errno, strerror(errno) ) ;
		return(errno) ;
	}

	/* 移动相应偏移量 */
	if( !strncmp( S_name.sysname, "AIX", 3 ) )
		lseek( *fd, 1024 * 4, SEEK_CUR ) ;
	else if( !strncmp( S_name.sysname, "Linux", 5 ) )
		;
	else if( !strncmp( S_name.sysname, "HP", 2 ) )
		;
	else if( !strncmp( S_name.sysname, "HP TRU64", 8 ) )
		;
	else
	{	
		fprintf( stderr, "不支持的操作系统[%s][%d][%s]\n", 
					S_name.sysname, errno, strerror(errno) ) ;
		return(errno) ;
	}
	
	return(errno) ;
}

/*
 *  FUNCTION NAME:  rawseek()
 *  FUNCTION    :   移动指针到对应位置
 *  INPUT       :   int  fd		文件描述符,打开设备后带回
 *					long int offset	偏移量
 *					int where		相对位置描述
 *						0	移动到文件头
 *						1	移动到文件尾
 *						2	从当前位置前移
 *						3	从当前位置后移
 *						4	从文件头开始后移
 *						5	从文件尾开始前移
 *  OUTPUT      :   系统错误码
 */
int rawseek( int fd, long int offset, int where )
{
	int		iRet ;

	memset( &iRet, 0, sizeof(int) ) ;

	switch(where)
	{
		case 0:
			iRet = lseek( fd, 0, SEEK_SET ) ;
			break ;
		case 1:
			iRet = lseek( fd, 0, SEEK_END ) ;
			break ;
		case 2:
			iRet = lseek( fd, offset * -1, SEEK_CUR ) ; 
			break ;
		case 3:
			iRet = lseek( fd, offset, SEEK_CUR ) ;
			break ;
		case 4:
			iRet = lseek( fd, 0, SEEK_SET ) ;
			if( iRet != 0 )
			{
				fprintf( stderr, 
						"lseek error[%d][%s]\n", errno, strerror(errno) );
				return(errno) ;
			}
			iRet = lseek( fd, offset, SEEK_CUR ) ;
			break ;
		case 5:
			iRet = lseek( fd, 0, SEEK_END ) ;
			if( iRet != 0 )
			{
				fprintf( stderr, 
						"fseek error[%d][%s]\n", errno, strerror(errno) );
				return(errno) ;
			}
			iRet = lseek( fd, offset * -1, SEEK_CUR ) ;
			break ;
		default:
			fprintf( stderr, "不支持的参数[%d]\n", where ) ;
			return(errno) ;
	}
	
	if( iRet < 0 )
	{
		fprintf( stderr, "1 lseek error[%d][%s]\n", errno, strerror(errno) );
		return(errno) ;
	}

	return(errno) ;
}

/*
 *  FUNCTION NAME:  rawread()
 *  FUNCTION    :   读裸设备
 *  INPUT       :   int	 fd			文件描述符
 *					char *buffer	存放读取内容
 *					long lCount		读取次数,以512BYTE为单位
 *  OUTPUT      :   系统错误码
 */
int rawread( int fd, char *buffer, long lCount )
{
	int	 n ;

	memset( &n, 0, sizeof(int) ) ;

	n = read( fd, buffer, lCount * 512 ) ;
	if( n < 0 )
	{
		fprintf( stderr, "读取数据出错[%d][%s]\n", errno, strerror(errno) ) ;
		return(errno) ;
	}

	return(errno) ;
}

/*
 *  FUNCTION NAME:  rawwrite()
 *  FUNCTION    :   写裸设备
 *  INPUT       :   int  fd			文件描述符
 *					char *buffer	存放读取内容
 *					long lCount		读取次数,以512BYTE为单位
 *  OUTPUT      :   系统错误码
 */
int rawwrite( int fd, char *buffer, long lCount )
{
	int	 n ;

	memset( &n, 0, sizeof(int) ) ;

	n = write( fd, buffer, lCount * 512 ) ;
	if( n < 0 )
	{
		fprintf( stderr, "写数据出错[%d][%s]\n", errno, strerror(errno) ) ;
		return(errno) ;
	}

	return(errno) ;
}

/*
 *  FUNCTION NAME:  rawclose()
 *  FUNCTION    :   关闭裸设备
 *  INPUT       :   int fd	文件描述符 
 *  OUTPUT      :   N/A
 */
int rawclose( int fd )
{
	close(fd) ;

	return(errno) ;
}

int main( int argc, char **argv )
{
	int		fd ;
	int		iRet ;
	int pos ;
	char	*buffer ;
	
	memset( &fd, 0, sizeof(int) ) ;
	memset( &iRet, 0, sizeof(int) ) ;
	
	iRet=posix_memalign(&buffer,512,1024);
	printf( "posix=[%d]\n", iRet ) ;
	memset( buffer, 0, 1024 ) ;

	iRet = israw(argv[1]) ;
	printf( "iRet=[%d]\n", iRet ) ;

	rawopen( argv[1], &fd, "rw" ) ;
	printf( "fd=[%d]\n", fd ) ;

	rawread( fd, buffer, 1 ) ;
	printf( "content=[%s][%02X %02X %02X %02X %02X %02X %02X %02X %02X %02X]\n",
			buffer,	buffer[0], buffer[1], buffer[2],
			buffer[3], buffer[4], buffer[5], buffer[6], buffer[7], buffer[8],
			buffer[9] ) ;

	printf( "read success\n" ) ;

	rawseek( fd, 512, 3 ) ;
	printf( "seek success\n" ) ;

	memset( buffer, 0, 1024 ) ;
	strcpy( buffer, "kao you" ) ;
	
	//printf("pre pos: %d \n",ftell(fd));
	rawwrite( fd, buffer, 1 ) ;
	printf( "write success\n" ) ;
	//printf("end pos: %d \n",ftell(fd));

	rawseek( fd, 512, 2 ) ;
	printf( "seek success\n" ) ;

	rawread( fd, buffer, 1 ) ;
	printf( "content=[%s][%02X %02X %02X %02X %02X %02X %02X %02X %02X %02X]\n", buffer, buffer[0], buffer[1], buffer[2],
			buffer[3], buffer[4], buffer[5], buffer[6], buffer[7], buffer[8],
			buffer[9] ) ;
	printf( "read success\n" ) ;

	rawclose(fd) ;

	return 0 ;
}
