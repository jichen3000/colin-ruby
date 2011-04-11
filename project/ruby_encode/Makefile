################################################################################
# lyjinger的makefile说明:
# 作者:lyjinger email:lyjinger@gmail.com
# 用法：make; make clean
#
# 1,本文件用于宿主机本地编译执行
#
# 2,请先参考lyjinger的rule.Makefile说明
#
# 3,INC变量设置需要加载的头文件目录，格式：-I[inc-path1] -I[inc-path2] ...
#   LIB变量设置需要加载的库文件目录，格式：-L[lib-path1] -L[lib-path2] ...
#
# 4,CFLAGS变量设置c编译选项
#   CXXFLAGS变量设置c++编译选项
#   LDFLAGS变量设置链接选项，需要加载的库在此处指出，格式：-l[lib1] -l[lib2] ...
#
# 5,SRCS变量设置需要编译的源文件，默认/注释掉的情况下编译当前目录所有.c文件
#   TARGET变量设置make的目标文件，默认/注释掉的情况下生成test可执行文件
#
################################################################################

INC	:=
LIB	:=

CROSS	:=
CFLAGS	:= -g -Wall
CXXFLAGS:=
LDFLAGS := -lssl

#SRCS	:= $(wildcard *.c)
#TARGET	:= test

include $(HOME)/rule.Makefile

