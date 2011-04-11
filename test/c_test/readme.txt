主要是测试ruby对于c代码的调用。
参考ruby Cookbook的第22章Extending Ruby with Other Languages
1. Writing C extending for Ruby
	主要文件：
	example.c
		c的源文件，注意在其中要引用ruby的头文件。#include <ruby.h>
		void Init_example()方法为ruby调用时自动使用的方法。其中声明ruby相关的module，class和methods
		很多的类型在ruby.h中声明。（src\ruby-1.8.6\ruby.h）
	extconf.rb
		扩展配置文件
	example_test.rb
		测试代码
	
	之后使用生成Makefile
	$ ruby extconf.rb
	使用make生成example.o example.so， example.so包含extension。
	$ make
	
	注意调用c代码并不是一个非常好的选择，因为它不运行在ruby的解释器上，所以错误没有办法捕捉。
	而且为了使用还对一般的c代码进行修改，使它符合ruby的规范才可以使用。
	
	还要测试
	不知道使用时要包含哪个文件，应该是example.o example.so的其中之一。
	
2. Using C library from Ruby


