#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <openssl/des.h>


/************************************************************************
 ** �������ã�
 **    3des-ecb���ܷ�ʽ��
 **    24λ��Կ������24λ���Ҳ�0x00��
 **    ��������8λ���룬���뷽ʽΪ����1λ��һ��0x01,��2λ������0x02,...
 **        ������8λ����ģ����油�˸�0x08��
 ************************************************************************/
int main(void)
{
	int docontinue = 1;

	unsigned char *data = "hello world!"; /* ���� */
	int data_len;
	int data_rest;
	unsigned char ch;

	unsigned char *src = NULL; /* ���������� */
	unsigned char *dst = NULL; /* ���ܺ������ */
	int len; 
	unsigned char tmp[8];
	unsigned char in[8];
	unsigned char out[8];

	char *k = "01234567899876543210"; /* ԭʼ��Կ */
	int key_len;
#define LEN_OF_KEY              24
	unsigned char key[LEN_OF_KEY]; /* ��������Կ */
	unsigned char block_key[9];
	DES_key_schedule ks,ks2,ks3;

	/* ���첹������Կ */
	key_len = strlen(k);
	memcpy(key, k, key_len);
	memset(key + key_len, 0x00, LEN_OF_KEY - key_len);

	/* ����������������ռ估����������� */
	data_len = strlen(data);
	data_rest = data_len % 8;
	len = data_len + (8 - data_rest);
	ch = 8 - data_rest;

	src = malloc(len);
	dst = malloc(len);
	if (NULL == src || NULL == dst)
	{
		docontinue = 0;
	}
	if (docontinue)
	{
		int count;
		int i;

		/* ���첹���ļ������� */
		memset(src, 0, len);
		memcpy(src, data, data_len);
		memset(src + data_len, ch, 8 - data_rest);

		/* ��Կ�û� */
		memset(block_key, 0, sizeof(block_key));
		memcpy(block_key, key + 0, 8);
		DES_set_key_unchecked((const_DES_cblock*)block_key, &ks);
		memcpy(block_key, key + 8, 8);
		DES_set_key_unchecked((const_DES_cblock*)block_key, &ks2);
		memcpy(block_key, key + 16, 8);
		DES_set_key_unchecked((const_DES_cblock*)block_key, &ks3);

		printf("before encrypt:");
		for (i = 0; i < len; i++)
		{
			printf("0x%.2X ", *(src + i));
		}
		printf("\n");

		/* ѭ������/���ܣ�ÿ8�ֽ�һ�� */
		count = len / 8;
		for (i = 0; i < count; i++)
		{
			memset(tmp, 0, 8);
			memset(in, 0, 8);
			memset(out, 0, 8);
			memcpy(tmp, src + 8 * i, 8);

			/* ���� */
			DES_ecb3_encrypt(tmp, in, &ks, &ks2, &ks3, DES_ENCRYPT);
			/* ���� */
			DES_ecb3_encrypt(in, out, &ks, &ks2, &ks3, DES_DECRYPT);
			/* �����ܵ����ݿ��������ܺ������ */
			memcpy(dst + 8 * i, out, 8);
		}

		printf("after decrypt :");
		for (i = 0; i < len; i++)
		{
			printf("0x%.2X ", *(dst + i));
		}
		printf("\n");
	}

	if (NULL != src)
	{
		free(src);
		src = NULL;
	}
	if (NULL != dst)
	{
		free(dst);
		dst = NULL;
	}

	return 0;
}

