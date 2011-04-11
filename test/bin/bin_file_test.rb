#pack
# 四位的int，小头
#V     |  Long, little-endian byte order
# 两位的int，小头
#v     |  Short, little-endian byte order
# 四位的int，大头
#N     |  Long, network (big-endian) byte order
# 两位的int，大头
#n     |  Short, network (big-endian) byte-order
# 四位的int，大小头根据操作系统
#I     |  Unsigned integer
#i     |  Integer
# 四位的int，大小头根据操作系统
#L     |  Unsigned long
#l     |  Long
# 两位的int，大小头根据操作系统
#S     |  Unsigned short
#s     |  Short
# 一位的int，不存在大小头
#C     |  Unsigned char
#c     |  Char

# 字符串可以随意的存取，但不知道采用什么编码方式的？

filename = "D:/tmp/log/bin.log"
file=File.open(filename,'rb')
block = file.read(11)
i = block.unpack("LSCvn")
p i
str = file.read(43)
p str

#file=File.open(filename,'wb')
#block =  [10,15].pack("LS")
#block += BlockHelper.gen_int_bin1(32)
#block += [255,255].pack("vn")
#file.write(block)
#str = "I am the colin!\n"
#in_size = file.write(str)
#p str.size
#p in_size
#c_str = "这是中文and english！\n"
#in_size = file.write(c_str)
#p c_str.size
#p in_size
file.close
p "ok"