################################################################################
# lyjinger的rule.Makefile说明:
# 作者:lyjinger email:lyjinger@gmail.com
#
# 1,默认加载./,./inc作为头文件目录
#   默认加载./,./lib作为库文件目录
# 
# 2,默认交叉编译变量CROSS为空
#   默认使用gcc,g++,ar,ld,objdump作为c编译器,c++编译器,打包器,链接器,反汇编器
#
# 3,默认编译当前目录下所有后缀为.c的文件并生成对应.o文件
#   默认生成可执行文件test
#   默认使用build.log作为编译日志记录文件
#
# 4,对$TARGET后缀为.so的执行编译(gcc -fPIC -shared)生成动态链接库
#   对$TARGET后缀为.a的执行打包(ar -rc)生成静态链接库
#   对其余的执行编译(gcc -o)生成可执行文件，并设置所有用户可执行
#
# 5,默认删除动作将删除对象文件,目标文件,日志文件,临时文件
#
# 6,请将rule.Makefile拷贝至$HOME目录下，配合Makefile(宿主机)/target.Makefile(目标板)来使用
#
################################################################################

CUR_DIR := $(shell pwd)
INC	+= -I$(CUR_DIR) \
	   -I$(CUR_DIR)/inc
LIB	+= -L$(CUR_DIR) \
	   -L$(CUR_DIR)/lib

CC	:= $(CROSS)gcc
CXX	:= $(CROSS)g++
AR	:= $(CROSS)ar
LD	:= $(CROSS)ld
OBJCOPY	:= $(CROSS)objcopy
OBJDUMP	:= $(CROSS)objdump

CFLAGS	+= $(INC)
CXXFLAGS+= $(INC)
LDFLAGS	+= $(LIB)

SRCS	?= $(wildcard *.c)
OBJS	:= $(addsuffix .o, $(basename $(SRCS)))
EXT_OBJS:= $(addprefix $(PFX_OBJ), $(EXT_OBJ))

LOGFILE	:= build.log
TARGET	?= test


.PHONY:all
all:$(TARGET)

$(TARGET): $(OBJS)
ifeq ($(suffix $(TARGET)), .so)
	$(CC) -fPIC -shared -nostartfiles -o $@ $^ $(EXT_OBJS)>>$(LOGFILE) 2>&1
	@mkdir -p lib
else
    ifeq ($(suffix $(TARGET)), .a)
		$(AR) -rc $@ $^ $(EXT_OBJS) >>$(LOGFILE) 2>&1
		@mkdir -p lib
    else
		$(CC) -o $@ $^ $(EXT_OBJS) $(LDFLAGS) >>$(LOGFILE) 2>&1
		@chmod 755 $@
    endif
endif

%.o:%.c	
	$(CC) -c $(CFLAGS) $< >>$(LOGFILE) 2>&1


.PHONY:clean
clean:
ifeq ($(suffix $(TARGET)), .so)
	$(RM) $(OBJS) $(TARGET) lib/$(TARGET) $(LOGFILE) *.core *~ .*.swp *.gdb
else
    ifeq ($(suffix $(TARGET)), .a)
		$(RM) $(OBJS) $(TARGET) lib/$(TARGET) $(LOGFILE) *.core *~ .*.swp *.gdb
    else
		$(RM) $(OBJS) $(TARGET) $(LOGFILE) *.core *~ .*.swp *.gdb
    endif
endif

