################################################################################
# lyjinger��rule.Makefile˵��:
# ����:lyjinger email:lyjinger@gmail.com
#
# 1,Ĭ�ϼ���./,./inc��Ϊͷ�ļ�Ŀ¼
#   Ĭ�ϼ���./,./lib��Ϊ���ļ�Ŀ¼
# 
# 2,Ĭ�Ͻ���������CROSSΪ��
#   Ĭ��ʹ��gcc,g++,ar,ld,objdump��Ϊc������,c++������,�����,������,�������
#
# 3,Ĭ�ϱ��뵱ǰĿ¼�����к�׺Ϊ.c���ļ������ɶ�Ӧ.o�ļ�
#   Ĭ�����ɿ�ִ���ļ�test
#   Ĭ��ʹ��build.log��Ϊ������־��¼�ļ�
#
# 4,��$TARGET��׺Ϊ.so��ִ�б���(gcc -fPIC -shared)���ɶ�̬���ӿ�
#   ��$TARGET��׺Ϊ.a��ִ�д��(ar -rc)���ɾ�̬���ӿ�
#   �������ִ�б���(gcc -o)���ɿ�ִ���ļ��������������û���ִ��
#
# 5,Ĭ��ɾ��������ɾ�������ļ�,Ŀ���ļ�,��־�ļ�,��ʱ�ļ�
#
# 6,�뽫rule.Makefile������$HOMEĿ¼�£����Makefile(������)/target.Makefile(Ŀ���)��ʹ��
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

