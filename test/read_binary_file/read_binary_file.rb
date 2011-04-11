# 说明：以二进制方式查看文件。
# 读取起始点 start_addr
# 读取的长度 read_len
# 以几进制来显示 show_carry
# 一排显示几个 show_col_count

require "colin_helper.rb"
require 'singleton'
class ReadBinaryFile
  include Singleton
#  @@my_self=nil
  attr_reader :log_file
  def self.show(file_name,start_addr,read_len,log_file_name=nil,is_test=false,
      show_row_count=16,show_col_count=16,show_carry=16)
    start_time=Time.now
    @@my_self = ReadBinaryFile.instance
#    if @@my_self == nil
#      @@my_self=ReadBinaryFile.new
#    end
    @@my_self.set_attrs(file_name,start_addr,read_len,show_row_count,show_col_count,show_carry,log_file_name,is_test)
    
    @@my_self.add_log( 'App Start! time: '+ColinHelper.str_time(start_time))
    
    @@my_self.read_file
    
    end_time=Time.now
    @@my_self.add_log( 'App End! time: '+ColinHelper.str_time(end_time))
    @@my_self.add_log( 'Through '+(end_time-start_time).to_f.to_s+' seconds!')
    
    @log_file.close if @log_file != nil
  end
  
  def initialize
    
  end
  def set_attrs(file_name,start_addr,read_len,show_row_count,show_col_count,show_carry,log_file_name,is_test)
    @file_name=file_name
    @start_addr=start_addr
    @read_len=read_len
    @show_row_count=show_row_count
    @show_col_count=show_col_count
    @show_carry=show_carry
    @is_test=is_test
    #如果log_file_name为空，就默认为当前目录下的.log文件。
    log_file_name ||= ColinHelper.log_name(__FILE__)
    puts log_file_name if is_test
    @log_file=File.new(log_file_name,'w+')
  end
  def add_log(mess,is_put=false)
    @log_file << mess+"\n"
    puts mess if (!is_put) and @is_test
    puts mess if is_put
  end
  def addr_str(str)
    ColinHelper.str16(str,8)+'h'
  end
  def read_file
    if !File.exist?(@file_name)
      add_log("Read file #{@file_name} is not exist!",true)
      exit
    end
    file=File.new(@file_name,"rb")
    add_log("Read file name: #{@file_name}.",true)
    add_log("",true)
    #
    file_size = File.size(@file_name)
    if @start_addr > file_size
      add_log("Read file start address(#{@start_addr}) large than file size(#{file_size})!",true)
      exit
    end
    if @start_addr + @read_len > file_size
      add_log("Read file read length(#{@read_len}) large than file size(#{file_size})!",true)
      add_log("Auto set read length is max!",true)
      @read_len = file_size - @start_addr
    end
    #跳过前面的。
    file.seek(@start_addr,IO::SEEK_CUR)
    readed_len = 0
    block_index = 0
    while readed_len < @read_len
      add_log("Block index: #{block_index.to_s.rjust(4,'0')}  addr: #{addr_str(readed_len+@start_addr)}",true)
      #读取当前的块
      cur_len = @show_row_count*@show_col_count
      cur_row_count = @show_row_count
      last_col_count = @show_col_count
      if readed_len + @show_row_count * @show_col_count > @read_len
        cur_len = @read_len - readed_len
        cur_row_count = cur_len / @show_col_count
        last_col_count = cur_len % @show_col_count
        cur_row_count += 1 if last_col_count > 0
      end
      read_block = file.read(cur_len)
      
      cur_row_count.times do |r_index|
        #不是最后一行
        line = addr_str(readed_len+ @start_addr+r_index* @show_col_count)+": "
        if r_index < cur_row_count - 1
          @show_col_count.times do |c_index|
            line += ColinHelper.str16(read_block[r_index* @show_col_count + c_index])+' '
          end
        #最后一行
        else
          last_col_count.times do |c_index|
            line += ColinHelper.str16(read_block[r_index * @show_col_count + c_index])+' '
          end
        end
        add_log(line,true)
      end
      
      add_log('',true)
      
      readed_len += cur_len
      block_index += 1
    end
    
  end
end

#file_name='D:\work\railsws\mc_rbs\read_ora_log\REDO03.LOG'
#file_name='D:\work\railsws\mc_rbs\read_ora_log\1_37.dbf'
#file_name='D:\work\railsws\mc_rbs\datafile\system01.dbf'
#file_name='D:\work\railsws\mc_rbs\read_ora_log\testdata\1_30050.dbf'
file_name='D:\msn_share\test\arch_0000236956.log'
#file_name='D:\work\railsws\mc_rbs\read_ora_log\bug\test16.dbf.new'
#file_name='D:\work\railsws\mc_rbs\read_ora_log\testdata\mcb_1_37.badb'
#file_name='D:\work\railsws\mc_rbs\datafile\test12.dbf'
#ReadBinaryFile.show(file_name,256*20,555*100,nil,true)
ReadBinaryFile.show(file_name,20793*512,1024,nil,true,8,16)
#file_name='D:\work\railsws\mc_rbs\read_ora_log\REDO03.LOG'
#ReadBinaryFile.show(file_name,0,24,nil,true,8,16)
