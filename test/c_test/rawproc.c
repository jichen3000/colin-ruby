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
 *  FUNCTION    :   �ж��Ƿ�Ϊ���豸
 *  INPUT       :   char *sFile		���豸�ļ���
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
 *  FUNCTION    :   �����豸
 *  INPUT       :   char *sFile		���豸�ļ���
 *					int  *fd		�ļ�������,���豸�����
 *					char *sOpt		��������: "r" ��, "w" д, "rw" ��д
 *  OUTPUT      :   ϵͳ������,��ϸ��Ϣ�����/usr/include/sys/errno.h
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
		fprintf( stderr, "�����豸����[%s][%d][%s]\n", 
							sFile, errno, strerror(errno) ) ;
		return(errno) ;
	}

	/* �ж���ʲô����ϵͳ */
	if( uname( &S_name ) == -1 )
	{
		fprintf( stderr, 
				"ȡ����ϵͳ��Ϣ����[%d][%s]\n", errno, strerror(errno) ) ;
		return(errno) ;
	}

	/* �ƶ���Ӧƫ���� */
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
		fprintf( stderr, "��֧�ֵĲ���ϵͳ[%s][%d][%s]\n", 
					S_name.sysname, errno, strerror(errno) ) ;
		return(errno) ;
	}
	
	return(errno) ;
}

/*
 *  FUNCTION NAME:  rawseek()
 *  FUNCTION    :   �ƶ�ָ�뵽��Ӧλ��
 *  INPUT       :   int  fd		�ļ�������,���豸�����
 *					long int offset	ƫ����
 *					int where		���λ������
 *						0	�ƶ����ļ�ͷ
 *						1	�ƶ����ļ�β
 *						2	�ӵ�ǰλ��ǰ��
 *						3	�ӵ�ǰλ�ú���
 *						4	���ļ�ͷ��ʼ����
 *						5	���ļ�β��ʼǰ��
 *  OUTPUT      :   ϵͳ������
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
			fprintf( stderr, "��֧�ֵĲ���[%d]\n", where ) ;
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
 *  FUNCTION    :   �����豸
 *  INPUT       :   int	 fd			�ļ�������
 *					char *buffer	��Ŷ�ȡ����
 *					long lCount		��ȡ����,��512BYTEΪ��λ
 *  OUTPUT      :   ϵͳ������
 */
int rawread( int fd, char *buffer, long lCount )
{
	int	 n ;

	memset( &n, 0, sizeof(int) ) ;

	n = read( fd, buffer, lCount * 512 ) ;
	if( n < 0 )
	{
		fprintf( stderr, "��ȡ���ݳ���[%d][%s]\n", errno, strerror(errno) ) ;
		return(errno) ;
	}

	return(errno) ;
}

/*
 *  FUNCTION NAME:  rawwrite()
 *  FUNCTION    :   д���豸
 *  INPUT       :   int  fd			�ļ�������
 *					char *buffer	��Ŷ�ȡ����
 *					long lCount		��ȡ����,��512BYTEΪ��λ
 *  OUTPUT      :   ϵͳ������
 */
int rawwrite( int fd, char *buffer, long lCount )
{
	int	 n ;

	memset( &n, 0, sizeof(int) ) ;

	n = write( fd, buffer, lCount * 512 ) ;
	if( n < 0 )
	{
		fprintf( stderr, "д���ݳ���[%d][%s]\n", errno, strerror(errno) ) ;
		return(errno) ;
	}

	return(errno) ;
}

/*
 *  FUNCTION NAME:  rawclose()
 *  FUNCTION    :   �ر����豸
 *  INPUT       :   int fd	�ļ������� 
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
