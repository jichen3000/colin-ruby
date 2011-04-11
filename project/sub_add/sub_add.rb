class SubBlock
  TIME_LINK_STR = '-->'
  attr_accessor :index, :content, :start_time_str, :end_time_str
  def initialize(block)
    raise "Wrong block! Because the block size less than 3!" if block.size < 3
    @index = block[0].to_i
    @start_time_str, @end_time_str = block[1].split(TIME_LINK_STR).map{|x| x.strip}
    @content = block
  end
  def change_time(ope,ope_time)
    if ope=="+"
      @start_time_str = SubBlock.timestr_add_usec(@start_time_str,ope_time)
      @end_time_str = SubBlock.timestr_add_usec(@end_time_str,ope_time)
    else
      @start_time_str = SubBlock.timestr_div_usec(@start_time_str,ope_time)
      @end_time_str = SubBlock.timestr_div_usec(@end_time_str,ope_time)
    end
  end
  def change_index(ope,ope_index)
    if ope=="+"
      @index += ope_index
    else
      @index -= ope_index
    end
  end
  def get_new_block()
    @content[0] = @index.to_s+"\n" 
    @content[1] = @start_time_str+" "+TIME_LINK_STR+" "+@end_time_str+"\n" 
    @content
  end
  def self.timestr_add_usec(timestr,usec)
    usec_to_timestr(timestr_to_usec(timestr)+usec)
  end
  def self.timestr_div_usec(timestr,usec)
    usec_to_timestr(timestr_to_usec(timestr)-usec)
  end
  def self.timestr_to_usec(timestr)
    arr = timestr.split(/[:,]/).map{|x| x.to_i}
    arr_to_usec(arr)  
  end
  def self.usec_to_timestr(usec)
    arr = usec_to_arr(usec)
    arr[0..2].map{|x| x.to_s.rjust(2,'0')}.join(":")+","+arr[3].to_s.rjust(3,'0')
  end
  def self.arr_to_usec(arr)
    arr[0]*3600000+arr[1]*60000+arr[2]*1000+arr[3]
  end
  def self.usec_to_arr(usec)
    arr = usec.divmod(3600000)
    arr[1] =  arr[1].divmod(60000)
    arr[1][1] = arr[1][1].divmod(1000)
    arr.flatten!
  end 
end

class SubFile
  attr_accessor :ope_object
  def initialize(filename,mode='r')
    @file = File.open(filename,mode)
  end
  def get_block
    block = []
    pre_line = ''
    while line = @file.gets
      break if line.strip.length == 0 and block.size>0
      block << line
    end
    return nil if block.size == 0
    block
  end
  def add_block(block)
    block.get_new_block.each do |line|
      @file << line
    end
    @file << "\n"
  end
  def close
    @file.close
  end
  def add_black_line
    @file << "\n"
  end
end
require 'fileutils'

class SubJoin
  attr_accessor :first_sub_file, :other_sub_files, :new_sub_file
  OPE = "+"
  def initialize(sub_filename,new_sub_filename)
    FileUtils.copy_file(sub_filename,new_sub_filename)
    @first_sub_file = SubFile.new(sub_filename)
    @new_sub_file = SubFile.new(new_sub_filename,'a')
    @new_sub_file.add_black_line
    @other_sub_files = []
  end
  def add_sub_file(sub_filename,ope_timestr)
    @other_sub_files << SubFile.new(sub_filename)
    @other_sub_files.last.ope_object = SubBlock.timestr_to_usec(ope_timestr)
  end
  def perform
    add_index = get_first_last_index
    @other_sub_files.each do |sub_file|
      while block = sub_file.get_block
        block = SubBlock.new(block)
        block.change_time(OPE,sub_file.ope_object)
        block.change_index(OPE,add_index)
        @new_sub_file.add_block(block)
      end
    end
    @new_sub_file.close
  end
  def get_first_last_index
    pre_block = nil
    while block = @first_sub_file.get_block
      pre_block = block
    end
    SubBlock.new(pre_block).index
  end
end
class SubChangeTime
  def initialize(sub_filename,new_sub_filename)
    @sub_file = SubFile.new(sub_filename)
    @new_sub_file = SubFile.new(new_sub_filename,'w')
  end
  def perform(ope,ope_timestr)
    ope_usec = SubBlock.timestr_to_usec(ope_timestr)
    while block = @sub_file.get_block
      block = SubBlock.new(block)
      block.change_time(ope,ope_usec)
      @new_sub_file.add_block(block)
    end
    @new_sub_file.close
  end
end