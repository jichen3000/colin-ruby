

class LoitSortPerform
#  MAX_BLOCK_NUMBER=4194304
#  MAX_BLOCK_NUMBER_1=4194303
  MAX_BLOCK_NUMBER = 524288
  MAX_BLOCK_NUMBER_1 = 524287
  #INTER_SIZE = 512
  #INTER_SIZE_S2 = 9
  #ARR_SIZE = 8192
  
  # 128 ibt start
#  INTER_SIZE = 128
#  INTER_SIZE_S2 = 7
#  INTER_SUB_SIZE = 16
#  ARR_SIZE = 32768
  # 128 ibt end

  # 64 ibt start
  INTER_SIZE = 64
  INTER_SIZE_S2 = 6
  INTER_SUB_SIZE = 8
  INTER = INTER_SIZE*INTER_SUB_SIZE
#  ARR_SIZE = 65536
#  ARR_SIZE = MAX_BLOCK_NUMBER/INTER_SIZE
  ARR_SIZE = MAX_BLOCK_NUMBER/512
  # 64 ibt end
  
  # 32 ibt start
#  INTER_SIZE = 32
#  INTER_SIZE_S2 = 5
#  INTER_SUB_SIZE = 8
#  ARR_SIZE = 131072
  # 32 ibt end
  INTER_COUNT = INTER_SIZE/INTER_SUB_SIZE
  AFN_SIZE=128
#  p_bin_arr(SOME_INTERSUB_ARR)
	class << self
	  def perform(from_filename,to_file_name)
      sort(get_total_arr(from_filename),to_file_name)
	  end
    # 打印二进制arr
    def p_bin_arr(arr)
      arr.each_with_index do |item,index|
        p "index:#{index},item_size:#{item.to_s(2).length},item:#{item.to_s(2)}"
      end
    end
    # 生成1的二进制数字表
    # 第一个长度和最后一个长度特殊
    # 例：gen_table_some(64,16)
    #"index:0,item_size:64,item:1111111111111111111111111111111111111111111111111111111111111111"
    #"index:1,item_size:16,item:1111111111111111"
    #"index:2,item_size:32,item:11111111111111110000000000000000"
    #"index:3,item_size:48,item:111111111111111100000000000000000000000000000000"
    #"index:4,item_size:64,item:1111111111111111000000000000000000000000000000000000000000000000"
    def gen_table_some(full_size,size)
      arr = []
      arr << (1<<(full_size))-1
      (full_size/size).times do |index|
          arr << ((1<<(size*(index+1)-1))-1 - ((1<<size*(index))-1))
      end
      arr
    end
    
    # 生成1的二进制数字表
    # 最后一个不用生成的
    #例：gen_table_some(4)
    #"index:0,item_size:1,item:1"
    #"index:1,item_size:2,item:10"
    #"index:2,item_size:3,item:100"
    #"index:3,item_size:4,item:1000"
    def gen_table_full(size)
      arr = []
      (size).times do |index|
        arr << (1<<index)
      end  
      arr
    end
    SOME_INTERSUB_ARR = LoitSortPerform.gen_table_some(INTER_SIZE,INTER_SUB_SIZE)
    FULL_INTER_ARR = LoitSortPerform.gen_table_full(INTER_SIZE)
    SOME_INTERSUB_ARR_2 = LoitSortPerform.gen_table_some(INTER_SUB_SIZE,INTER_SUB_SIZE)
    FULL_INTER_ARR_2 = LoitSortPerform.gen_table_full(INTER_SUB_SIZE)
    def gen_0_arr
      arr = []
      ARR_SIZE.times {arr << 0}
      arr
    end
    
    def get_total_arr_blockcount(filename)
      file = File.open(filename,'r')
      afn_arr = []
      index = 0
      while !file.eof
        line = file.readline
        afn,dba,block_count = line.split(' ')
        afn = afn.hex
        dba = dba.hex
        block_count = block_count.to_i if block_count
        arr = afn_arr[afn-1]
        # 没有取到数组，就重新生成一个全0的arr
        if not arr
          arr = gen_0_arr
          afn_arr[afn-1] = arr
        end
        block_no = (dba & MAX_BLOCK_NUMBER_1)
        # 取余+1作为值，不过和下面的-1抵消
        # 因为要处理整除为0的情况
        value_index = (block_no % INTER_SIZE)+1
        # 取商作为arr的index
        arr_index = (block_no >> INTER_SIZE_S2)
        if not (block_count and block_count>1)
          # 用或，记录值
          # value_index要-1，不过和上面的+1抵消
          arr[arr_index] = (arr[arr_index]|(1<<(value_index-1)))
        else
          do_get_blockcount(arr,arr_index,value_index,block_count)
        end
#        p "afn:#{afn},block_no:#{block_no},arr_index:#{arr_index},value_index:#{value_index},arr[arr_index]:#{arr[arr_index]}"
        index += 1
      end
#      puts_afn_arr(afn_arr)
      file.close
      afn_arr
    end
    def get_total_arr(filename)
      file = File.open(filename,'r')
      afn_arr = []
      index = 0
      while !file.eof
        line = file.readline
        afn,dba = line.split(' ')
        afn = afn.hex
        dba = dba.hex
        arr = afn_arr[afn-1]
        # 没有取到数组，就重新生成一个全0的arr
        if not arr
          arr = gen_0_arr
          afn_arr[afn-1] = arr
        end
        block_no = (dba & MAX_BLOCK_NUMBER_1)
        # 取余+1作为值，不过和下面的-1抵消
        # 因为要处理整除为0的情况
        value_index = (block_no % INTER_SIZE)+1
#        value_index = (block_no % 8)+1
        # 取商作为arr的index
        arr_index = (block_no >> INTER_SIZE_S2)
        # 用或，记录值
        # value_index要-1，不过和上面的+1抵消
        arr[arr_index] = (arr[arr_index]|(1<<(value_index-1)))
#        p "afn:#{afn},block_no:#{block_no},arr_index:#{arr_index},value_index:#{value_index},arr[arr_index]:#{arr[arr_index]}"
        index += 1
      end
#      puts_afn_arr(afn_arr)
      file.close
      afn_arr
    end
    def get_total_arr_short(filename)
      file = File.open(filename,'r')
      afn_arr = []
      index = 0
      while !file.eof
        line = file.readline
        afn,dba = line.split(' ')
        afn = afn.hex
        dba = dba.hex
        arr = afn_arr[afn-1]
        # 没有取到数组，就重新生成一个全0的arr
        if not arr
          arr = gen_0_arr
          afn_arr[afn-1] = arr
        end
        block_no = (dba & MAX_BLOCK_NUMBER_1)
        # 取余+1作为值，不过和下面的-1抵消
        # 因为要处理整除为0的情况
#        value_index = (block_no % INTER_SIZE)+1
        value_index = (block_no % INTER_SIZE)
        value_index = (value_index / 8)+1
        # 取商作为arr的index
        arr_index = (block_no >> INTER_SIZE_S2)
        # 用或，记录值
        # value_index要-1，不过和上面的+1抵消
        arr[arr_index] = (arr[arr_index]|(1<<(value_index-1)))
    #        p "afn:#{afn},block_no:#{block_no},arr_index:#{arr_index},value_index:#{value_index},arr[arr_index]:#{arr[arr_index]}"
        index += 1
      end
    #      puts_afn_arr(afn_arr)
      file.close
      afn_arr
    end
    def get_total_arr_short_3(filename)
      file = File.open(filename,'r')
      afn_arr = []
      index = 0
      while !file.eof
        line = file.readline
        afn,dba = line.split(' ')
        afn = afn.hex
        dba = dba.hex
        arr = afn_arr[afn-1]
        # 没有取到数组，就重新生成一个全0的arr
        if not arr
          arr = gen_0_arr
          afn_arr[afn-1] = arr
        end
        block_no = (dba & MAX_BLOCK_NUMBER_1)
        # 取余+1作为值，不过和下面的-1抵消
        # 因为要处理整除为0的情况
#        value_index = (block_no % INTER_SIZE)+1
        value_index = (block_no % 512)
        value_index = (value_index / 8) + 1
        # 取商作为arr的index
        arr_index = (block_no >> 9)
        # 用或，记录值
        # value_index要-1，不过和上面的+1抵消
        arr[arr_index] = (arr[arr_index]|(1<<(value_index-1)))
    #        p "afn:#{afn},block_no:#{block_no},arr_index:#{arr_index},value_index:#{value_index},arr[arr_index]:#{arr[arr_index]}"
        index += 1
      end
    #      puts_afn_arr(afn_arr)
      file.close
      afn_arr
    end
    # 从
    def do_get_blockcount(arr,arr_index,value_index,block_count)
      if block_count + value_index -1 < INTER_SIZE
        gen_value = gen_continue_1(value_index+1, value_index+block_count)
        arr[arr_index] = (arr[arr_index]|gen_value)
      else
        add_no = 0
        remain = block_count + value_index
        while remain > 0
          if add_no == 0
            start_index = value_index+1
          else
            start_index = 1
          end
          if remain > INTER_SIZE
            end_index = INTER_SIZE
          else
            end_index = remain
          end
          gen_value = gen_continue_1(start_index, end_index)
          arr[arr_index+add_no] = (arr[arr_index+add_no]|gen_value)
          add_no += 1
          remain -= INTER_SIZE
        end
      end
    end
    def gen_continue_1(start_index, end_index)
      (1<<(end_index)) - (1<<(start_index-1))
    end
    def sort(afn_arr,save_filename)
      file = File.open(save_filename,'w')
      tmp_arr = []
      # afn array
      afn_arr.each_with_index do |arr,afn_index|
        # value array
#        arr.each_with_index do |value,arr_index|
        arr_index = 0
        arr.each do |value|
          #
#          get_block_single_16(value,tmp_arr,1,16)
#      if (value & FULL_INTER_ARR[5]) != 0 
#        tmp_arr << [6,1]
#      end

#          get_block_ignore_single_2(value,tmp_arr)
          get_block_ignore_single_3(value,tmp_arr)
#          get_block_64(value,tmp_arr)
#          get_block_32(value,tmp_arr)
          tmp_arr.each do |item|
#            afn = afn_index+1
#            block_number = item[0]+arr_index*INTER_SIZE
#            block_count = item[1]
            file << (afn_index+1).to_s+' '+(arr_index*INTER_SIZE+item[0]-1).to_s+
              ' '+item[1].to_s+"\n"
#            p "afn:#{afn},block_number:#{block_number},block_count:#{block_count},"
            
          end 
          tmp_arr.clear
          arr_index += 1
        end
      end
      file.close
    end
    def puts_afn_arr(afn_arr)
      afn_arr.each_with_index do |arr,afn_index|
        p "arr index(#{afn_index+1}):"
        arr.each_with_index do |item,index|
          if item!=0
            p "index:#{index},item:#{item.to_s}:#{item.to_s(2)}"
          end
        end
      end
    end
    def get_block_64(value,r_arr)
      # 全为1的比较
      if value == 0
        return r_arr
      elsif value == SOME_INTERSUB_ARR.first
        r_arr << [1, INTER_SIZE]
        return r_arr
      else
        # 分段全为1的比较
        # 这个段全为0的话就不做处理
        case (value & SOME_INTERSUB_ARR[1])
        when 0 
        when SOME_INTERSUB_ARR[1] then r_arr << [1,16]
        else get_block_single_16(value,r_arr,1,16)
        end
        # 分段全为1的比较
        case (value & SOME_INTERSUB_ARR[2])
        when 0 
        when SOME_INTERSUB_ARR[2] then r_arr << [17,16]
        else get_block_single_16(value,r_arr,17,32)
        end
        # 分段全为1的比较
        case (value & SOME_INTERSUB_ARR[3])
        when 0 
        when SOME_INTERSUB_ARR[3] then r_arr << [33,16]
        else get_block_single_16(value,r_arr,33,48)
        end
        # 分段全为1的比较
        case (value & SOME_INTERSUB_ARR[4])
        when 0 
        when SOME_INTERSUB_ARR[4] then r_arr << [49,16]
        else get_block_single_16(value,r_arr,49,64)
        end
      end
      return r_arr
    end
    def get_block(value,r_arr)
      # 全为1的比较
      if value == 0
        return r_arr
      elsif value == SOME_INTERSUB_ARR.first
        r_arr << [1, INTER_SIZE]
        return r_arr
      else
        # 分段全为1的比较
        # 这个段全为0的话就不做处理
        INTER_COUNT.times do |index|
          index_1 = index+1
          start = INTER_SUB_SIZE*index+1
          case (value & SOME_INTERSUB_ARR[index_1])
          when 0 
          when SOME_INTERSUB_ARR[index_1] then r_arr << [start, INTER_SUB_SIZE]
          else get_block_single_16(value, r_arr, start, INTER_SUB_SIZE*index_1)
          end
        end
      end
      return r_arr
    end
    def get_block_ignore_single(value,r_arr)
      # 全为1的比较
      if value == 0
        return r_arr
      elsif value == SOME_INTERSUB_ARR.first
        r_arr << [1, INTER_SIZE]
        return r_arr
      else
        # 分段全为1的比较
        # 这个段全为0的话就不做处理
        INTER_COUNT.times do |index|
          index_1 = index+1
          start = INTER_SUB_SIZE*index+1
#          p "index:#{index},value:#{value},SOME_INTERSUB_ARR[index_1]:#{SOME_INTERSUB_ARR[index_1]}"
          # 忽略单个为1的情况
          if (value & SOME_INTERSUB_ARR[index_1]) != 0
            r_arr << [start, INTER_SUB_SIZE]
          end
        end
      end
      return r_arr
    end
    def get_block_ignore_single_2(value,r_arr)
      # 全为1的比较
      if value == 0
        return r_arr
      elsif value == SOME_INTERSUB_ARR_2.first
        r_arr << [1, INTER_SIZE]
        return r_arr
      else
        # 分段全为1的比较
        # 这个段全为0的话就不做处理
        INTER_COUNT.times do |index|
          start = INTER_SUB_SIZE*index+1
#          p INTER_COUNT
#          p "index:#{index},value:#{value},FULL_INTER_ARR_2[index]:#{FULL_INTER_ARR_2[index]}"
          # 忽略单个为1的情况
          if (value & FULL_INTER_ARR_2[index]) != 0
            r_arr << [start, INTER_SUB_SIZE]
          end
        end
      end
      return r_arr
    end
    def get_block_ignore_single_3(value,r_arr)
      # 全为1的比较
      if value == 0
        return r_arr
      elsif value == SOME_INTERSUB_ARR.first
        r_arr << [1, 512]
        return r_arr
      else
        # 分段全为1的比较
        # 这个段全为0的话就不做处理
        INTER_COUNT.times do |index|
          index_1 = index+1
          start = 8*index+1
          case (value & SOME_INTERSUB_ARR[index_1])
          when 0 
          when SOME_INTERSUB_ARR[index_1] then r_arr << [(start-1)*8+1, 64]
          else get_block_single_16_3(value, r_arr, start, 8*index_1)
          end
        end
      end
      return r_arr
    end
    def get_block_single_16(value,r_arr,start_index,end_index)
      start_index.upto(end_index) do |index|
#        p "index:#{index},FULL_INTER_ARR[index-1]:#{FULL_INTER_ARR[index-1]}"
#        p "value & FULL_INTER_ARR[index-1]:#{value & FULL_INTER_ARR[index-1]}"
#        if (value & FULL_INTER_ARR[index-1]) == 0
#          p "value           :#{value.to_s(2)}" 
#          p "FULL_INTER_ARR[index-1]:#{FULL_INTER_ARR[index-1].to_s(2)}" 
#        end
        if (value & FULL_INTER_ARR[index-1]) != 0 
          r_arr << [index,1]
        end
      end
      r_arr
    end
    def get_block_single_16_3(value,r_arr,start_index,end_index)
      start_index.upto(end_index) do |index|
#        p "index:#{index},FULL_INTER_ARR[index-1]:#{FULL_INTER_ARR[index-1]}"
#        p "value & FULL_INTER_ARR[index-1]:#{value & FULL_INTER_ARR[index-1]}"
        if (value & FULL_INTER_ARR[index-1]) != 0 
          r_arr << [(index-1)*8+1,8]
        end
      end
      r_arr
    end
	end
end
require 'benchmark'
r_arr = nil
Benchmark.bm do |i|
#  i.report("get ") {r_arr = LoitSortPerform.get_total_arr('testloit_1000w.log')}
#  i.report("sort") {LoitSortPerform.sort(r_arr,'r1000w_ig.log')}
  i.report("get ") {r_arr = LoitSortPerform.get_total_arr_short_3('testloit_1000w_lb.log')}
  i.report("sort") {LoitSortPerform.sort(r_arr,'rtestloit_1000w_lb_ig_2.log')}
end
p "ok"
#sort('testloit01.log')
#p "ok"