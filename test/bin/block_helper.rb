#class ReadBlockService
#  @@is_reverse = false
#  @@cur_block = nil
#  @@cur_content = nil
#  class << self
#    def set_is_reverse(is_reverse)
#      @@is_reverse = is_reverse
#    end
#    def get_is_reverse
#      @@is_reverse
#    end
#    def set_cur_block(cur_block)
#      @@cur_block = cur_block
#    end
#    def set_cur_content(cur_content)
#      @@cur_content = cur_content
#    end
#    def r_c(offset,size=4)
#  #    ReadBlockService.read_data(@@cur_content,offset,size=4)
#      if @@is_reverse
#        @@cur_content[offset..(offset+size-1)].reverse 
#      else
#        @@cur_content[offset..(offset+size-1)] 
#      end    
#    end
#    def r_b(offset,size=4)
#      if @@is_reverse
#        @@cur_block[offset,size].reverse 
#      else
#        @@cur_block[offset,size] 
#      end    
##      if @@is_reverse
##        @@cur_block[offset..(offset+size-1)].reverse 
##      else
##        @@cur_block[offset..(offset+size-1)] 
##      end    
#    end
#    def r_b_two(a_offset,a_size,b_offset,b_size)
#      if @@is_reverse
#        (@@cur_block[a_offset,1] + @@cur_block[b_offset,b_size]).reverse
#      else
#        @@cur_block[b_offset-1,b_size] + @@cur_block[a_offset+3,a_size]
#      end    
#    end
#    def r_b_o(offset,size=4)
#      @@cur_block[offset,size] 
##      @@cur_block[offset..(offset+size-1)] 
#    end
#    def gen_null_block(block_size)
#      arr = Array.new
#      block_size.times do |item|
#        arr << '00'
#      end
#      arr.pack("H2"*arr.size)
#    end
#    def write_block(offset,sub_block)
#      @@cur_block[offset..offset+sub_block.size-1] = sub_block
#    end
#    # arr = ["23","45","96"]
#    def write_block_arr_2(offset,arr)
#      str = nil
#      if @@is_reverse
#        str = arr.reverse.pack("H2"*arr.size)
#      else
#        str = arr.pack("H2"*arr.size) 
#      end    
#      block[offset..offset+str.size-1] = str
#    end
#    def read_data(data,offset,size=4)
#      if @@is_reverse
#        data[offset..(offset+size-1)].reverse 
#      else
#        data[offset..(offset+size-1)] 
#      end    
#    end
#  end
#end

class BlockHelper
  class << self
    def set_opposite_reverse(is_opposite_reverse=true)
      if is_opposite_reverse
        alias read read_reverse 
      else
        alias read read_normal
      end
    end
    def read_reverse(block,offset,size=4)
#      puts "read_reverse"
      block[offset,size].reverse
    end
    def read_normal(block,offset,size=4)
#      puts "read_normal"
      block[offset,size]
    end
    def read(block,offset,size=4)
      raise "No alais method!"
    end
    # I     |  Unsigned integer
    def gen_int_bin4(int)
      [int].pack("I")
    end
    # S     |  Unsigned short
    def gen_int_bin2(int)
      [int].pack("S")
    end
    # 单个字节的
    def gen_int_bin1(int)
      [int].pack("C")
    end
    # 两个字节长度的，小头的。linux,windows
    def gen_short_little_endian(int)
      [int].pack("v")
    end
    # 两个字节长度的，大头的。hp,aix
    def gen_short_big_endian(int)
      [int].pack("n")
    end
  end
end
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

#BlockHelper.set_opposite_reverse(true)
#BlockHelper.read(nil,nil,nil)
