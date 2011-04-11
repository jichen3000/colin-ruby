filename = File.join(File.dirname(__FILE__),"int.bin")
File.open(filename,'wb') do |file|
  # 用四字节保存 20000=4E20 大头的，小头的为V
  file.write([1,20000].pack("NN"))
  # 
  file.write(["Hello","Colin"].pack("a5a5"))
  # 字符串可以不用转换直接保存
  file.write("other")
end
p "ok"

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