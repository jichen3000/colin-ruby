def barr2str16(b_arr,len = nil)
  len ||= 2*b_arr.length
  b_arr.unpack('H'+(len).to_s).join.upcase
end
def barr2int(b_arr)
  if b_arr.length == 4
    b_arr.unpack('l')      #将b_arr转换成4字节的Interge
  elsif b_arr.length == 2
    b_arr.unpack('v')      #将b_arr转换成2字节的Interge
  end
end
def barr2int_o(b_arr)
  b_arr.unpack('C4')
end

tname = 'D:\work\testdata\new\users04.dbf'
f = File.new(tname,'rb')
block = f.read(4)


puts barr2str16(block)
puts barr2int(block)
puts barr2int_o(block)