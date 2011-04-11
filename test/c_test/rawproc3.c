#include <stdio.h>
#include <errno.h>
#include <sys/utsname.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>
#include <fcntl.h>
#define _XOPEN_SOURCE 600
#include <stdlib.h>

#define _GNU_SOURCE
#define	TRUE	1
#define	FALSE	0 

/*
 *  FUNCTION NAME:  israw()
 *  FUNCTION    :   Å¶ÏǷñã±¸
 *  INPUT       :   char *sFile		ÂÉ±¸Î¼þÃ
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
 *  FUNCTION    :   ´òã±¸
 *  INPUT       :   char *sFile		ÂÉ±¸Î¼þÃ
 *					int  *fd		Î¼þÃÊ·ûªÉ±¸ºóØ *					char *sOpt		²Ù÷Í "r" ¶Á "w" д, "rw" ¶Á´
 *  OUTPUT      :   ϵͳ´íÂ,ÏϸÐϢÇ¶ÔÕusr/include/sys/errno.h
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
		fprintf( stderr, "´òã±¸³ö%s][%d][%s]\n", 
							sFile, errno, strerror(errno) ) ;
		return(errno) ;
	}

	/* Å¶ÏÇ²ô²Ù÷³ */
	if( uname( &S_name ) == -1 )
	{
		fprintf( stderr, 
				"ȡ²Ù÷³ÐϢ³ö%d][%s]\n", errno, strerror(errno) ) ;
		return(errno) ;
	}

	/* Ò¶¯ÏӦƫÒ */
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
		fprintf( stderr, "²»֧³ֵĲÙ÷³[%s][%d][%s]\n", 
					S_name.sysname, errno, strerror(errno) ) ;
		return(errno) ;
	}
	
	return(errno) ;
}

/*
 *  FUNCTION NAME:  rawseek()
 *  FUNCTION    :   Ò¶¯ָÕµ½¶Ô¦λÖ
 *  INPUT       :   int  fd		Î¼þÃÊ·ûªÉ±¸ºóØ *					long int offset	ƫÒ
 *					int where		Ï¶Ô»ÖÃÊ
 *						0	Ò¶¯µ½Î¼þͷ
 *						1	Ò¶¯µ½Î¼þβ
 *						2	´ӵ±ǰλÖǰÒ
 *						3	´ӵ±ǰλÖºó *						4	´Óļþͷ¿ªʼºó *						5	´Óļþβ¿ªʼǰÒ
 *  OUTPUT      :   ϵͳ´íÂ
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
			fprintf( stderr, "²»֧³ֵĲÎýn", where ) ;
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
 *  FUNCTION    :   ¶Áã±¸
 *  INPUT       :   int	 fd			Î¼þÃÊ·û				char *buffer	´æ¶Á¡ÄÈ
 *					long lCount		¶Á¡´Îý2BYTEΪµ¥λ
 *  OUTPUT      :   ϵͳ´íÂ
 */
int rawread( int fd, char *buffer, long lCount )
{
	int	 n ;

	memset( &n, 0, sizeof(int) ) ;

	n = read( fd, buffer, lCount * 512 ) ;
	if( n < 0 )
	{
		fprintf( stderr, "¶Á¡Ê¾ݳö%d][%s]\n", errno, strerror(errno) ) ;
		return(errno) ;
	}

	return(errno) ;
}

/*
 *  FUNCTION NAME:  rawwrite()
 *  FUNCTION    :   дÂÉ±¸
 *  INPUT       :   int  fd			Î¼þÃÊ·û				char *buffer	´æ¶Á¡ÄÈ
 *					long lCount		¶Á¡´Îý2BYTEΪµ¥λ
 *  OUTPUT      :   ϵͳ´íÂ
 */
int rawwrite( int fd, char *buffer, long lCount )
{
	int	 n ;

	memset( &n, 0, sizeof(int) ) ;

	n = write( fd, buffer, lCount * 512 ) ;
	if( n < 0 )
	{
		fprintf( stderr, "дÊ¾ݳö%d][%s]\n", errno, strerror(errno) ) ;
		return(errno) ;
	}

	return(errno) ;
}

/*
 *  FUNCTION NAME:  rawclose()
 *  FUNCTION    :   ¹رÕã±¸
 *  INPUT       :   int fd	Î¼þÃÊ·û  OUTPUT      :   N/A
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
/*	char	buffer[1024] ;  */
        char *buffer; 
	
	memset( &fd, 0, sizeof(int) ) ;
	memset( &iRet, 0, sizeof(int) ) ;
        iRet=posix_memalign(&buffer,512,1024);
        printf( "iRet=[%d]\n", iRet ) ;
 
	memset( buffer, 0, 1024 ) ; 

	iRet = israw(argv[1]) ;
	printf( "iRet=[%d]\n", iRet ) ;

	rawopen( argv[1], &fd, "rw" ) ;
	printf( "fd=[%d]\n", fd ) ;

	rawread( fd, buffer, 2 ) ;
	printf( "content=[%s][%02X %02X %02X %02X %02X %02X %02X %02X %02X %02X]\n",
			buffer,	buffer[0], buffer[1], buffer[2],
			buffer[3], buffer[4], buffer[5], buffer[6], buffer[7], buffer[8],
			buffer[9] ) ;

	printf( "read success\n" ) ;

	//memset( buffer, 0, 1024 ) ;
	//strcpy( buffer, "CCCCCCCCCCCCCCCCCCCCCCCCAAAAAAAAAAAAAAAAA" ) ;

	//rawwrite( fd, buffer, 1 ) ;
	//printf( "write success\n" ) ;

	//rawseek( fd, 512, 3 ) ;
	//printf( "seek success\n" ) ;

	rawseek( fd, 512, 3 ) ;
	printf( "seek success\n" ) ;


	rawread( fd, buffer, 1 ) ;
	printf( "content=[%s][%02X %02X %02X %02X %02X %02X %02X %02X %02X %02X]\n", buffer, buffer[0], buffer[1], buffer[2],
			buffer[3], buffer[4], buffer[5], buffer[6], buffer[7], buffer[8],
			buffer[9] ) ;
	printf( "read success\n" ) ;

	rawclose(fd) ;

	return 0 ;
}

