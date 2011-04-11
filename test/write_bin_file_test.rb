require 'colin_helper'

def write_file(filename)
  file = File.new(filename,'r+b')
  arr = ["a","b","c"]
#  i_arr = ["23","45","96"]
#  block = i_arr.pack("H2"*i_arr.size)
  i_arr = ["2300","4500","9600"]
  block = i_arr.pack("H4"*i_arr.size)
  puts ColinHelper.barr2str16(block)
  puts block
  file.seek(9,IO::SEEK_CUR)
  file.write(block)
  file.close
end

def read_file(filename)
  file = File.new(filename,'rb')
  block = file.read(3)
  puts ColinHelper.barr2str16(block)
  file.close
end

def gen_null_block(block_size)
  arr = Array.new
  block_size.times do |item|
    arr << '00'
  end
  arr.pack("H2"*arr.size)
end
def write_block(block,offset,sub_block)
  block[offset..offset+sub_block.size-1] = sub_block
end
def write_block_arr_2(block,offset,arr)
  str = arr.pack("H2"*arr.size)
  block[offset..offset+str.size-1] = str
end
filename = File.join(File.dirname(__FILE__),'source.rpb')
#write_file(filename)
#read_file(filename)
block = gen_null_block(16)
puts ColinHelper.barr2str16(block)
i_arr = ["2300","4500","9600"]
str = i_arr.reverse.pack("H4"*i_arr.size)
write_block(block,4,str) 
puts ColinHelper.barr2str16(block)
write_block_arr_2(block,6,i_arr)
puts ColinHelper.barr2str16(block)
puts "ok"