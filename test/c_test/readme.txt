��Ҫ�ǲ���ruby����c����ĵ��á�
�ο�ruby Cookbook�ĵ�22��Extending Ruby with Other Languages
1. Writing C extending for Ruby
	��Ҫ�ļ���
	example.c
		c��Դ�ļ���ע��������Ҫ����ruby��ͷ�ļ���#include <ruby.h>
		void Init_example()����Ϊruby����ʱ�Զ�ʹ�õķ�������������ruby��ص�module��class��methods
		�ܶ��������ruby.h����������src\ruby-1.8.6\ruby.h��
	extconf.rb
		��չ�����ļ�
	example_test.rb
		���Դ���
	
	֮��ʹ������Makefile
	$ ruby extconf.rb
	ʹ��make����example.o example.so�� example.so����extension��
	$ make
	
	ע�����c���벢����һ���ǳ��õ�ѡ����Ϊ����������ruby�Ľ������ϣ����Դ���û�а취��׽��
	����Ϊ��ʹ�û���һ���c��������޸ģ�ʹ������ruby�Ĺ淶�ſ���ʹ�á�
	
	��Ҫ����
	��֪��ʹ��ʱҪ�����ĸ��ļ���Ӧ����example.o example.so������֮һ��
	
2. Using C library from Ruby


