#! /bin/ruby
#version 1.01 2007-04-26 by Colin J

def file_place(t_file_name,s_file_name,block_size,block_number,
    t_skip_block_size,t_skip_block_number,s_skip_block_size,s_skip_block_number)
  #测试文件是否存在
  if !File.exist?(t_file_name)
    puts "target file #{t_file_name} is not exits!"
  end
  if !File.exist?(s_file_name)
    puts "source file #{s_file_name} is not exits!"
  end

  t_file=File.new(t_file_name,"r+b")
  s_file=File.new(s_file_name,"rb")
  file_skip(t_file,t_skip_block_size,t_skip_block_number)
  file_skip(s_file,s_skip_block_size,s_skip_block_number)
  block_number.times do |i|
    if t_file.eof 
      puts "target file #{t_file_name} is short!" 
      break
    elsif s_file.eof
      puts "source file #{s_file_name} is short!" 
      break
    else
      r= s_file.read(block_size)
      t_file.write(r)
    end
  end  
end
#在文件中跳过一段
def file_skip(file,block_size,block_number)
  if block_size>0 and block_number>0
    if File.size(file)>block_size*block_number
      file.read(block_size*block_number)
    else
      puts "file #{file.dirname} is short!" 
    end
  end 
end

def get_hash_args(array_args,hash_args)
  array_args.each do |array_arg|
    hash_args.each_key do |key|
      re = Regexp.new(key+'=(.*)')
      if array_arg =~ re
        hash_args[key]=$1
        break
      end
    end
  end
  hash_args
end

#目标文件名 t_file
#源文件名 s_file
#将s_file中的部分内容拷贝到t_file
#块的大小 block_size (可选) 默认512 单位为bytes。
#块的数量 block_number (可选) 默认2
#目标文件起始跳过块的大小 t_skip_block_size (可选) 默认和block_size一样
#目标文件起始跳过块的数量 t_skip_block_number (可选) 默认0
#源文件起始跳过块的大小 s_skip_block_size (可选) 默认和block_size一样
#源文件起始跳过块的数量 s_skip_block_number (可选) 默认0
#是否打印测试参数 is_test (可选) 默认false
# file_place.rb t_file=D:\work\railsws\quiz\other\w_test 
#     s_file=D:\work\railsws\quiz\other\test
#     block_size=512 block_number=2 
#     t_skip_block_size=512 t_skip_block_number=0 
#     s_skip_block_size=512 s_skip_block_number=0 
#     is_test=true
STR_T_FILE = 't_file'
STR_S_FILE = 's_file'
STR_BLOCK_SIZE = 'block_size'
STR_BLOCK_NUMBER = 'block_number'
STR_T_SKIP_BLOCK_SIZE = 't_skip_block_size'
STR_T_SKIP_BLOCK_NUMBER = 't_skip_block_number'
STR_S_SKIP_BLOCK_SIZE = 's_skip_block_size'
STR_S_SKIP_BLOCK_NUMBER = 's_skip_block_number'
STR_IS_TEST = 'is_test'
if ARGV.size<2 or ARGV.size>9
  puts "Usage: #{File.basename($PROGRAM_NAME)} t_file=file_path s_file=file_path \n"+
       "       [block_size=512] [block_number=2]"+ 
       "       [t_skip_block_size=512] [t_skip_block_number=0]"+ 
       "       [s_skip_block_size=512] [s_skip_block_number=0]"+ 
       "       [is_test=false]"+
       "Note: block_size's unit is byte"
  exit
end
args = {STR_T_FILE=>nil,STR_S_FILE=>nil,STR_BLOCK_SIZE=>'512',STR_BLOCK_NUMBER=>'2',
    STR_T_SKIP_BLOCK_SIZE=>'-1',STR_T_SKIP_BLOCK_NUMBER=>'0',
    STR_S_SKIP_BLOCK_SIZE=>'-1',STR_S_SKIP_BLOCK_NUMBER=>'0',
    STR_IS_TEST=>'false'} 
get_hash_args(ARGV,args)
#参数转换
args[STR_BLOCK_SIZE]=args[STR_BLOCK_SIZE].to_i
args[STR_BLOCK_NUMBER]=args[STR_BLOCK_NUMBER].to_i
args[STR_T_SKIP_BLOCK_SIZE]=args[STR_T_SKIP_BLOCK_SIZE].to_i
args[STR_T_SKIP_BLOCK_NUMBER]=args[STR_T_SKIP_BLOCK_NUMBER].to_i
args[STR_S_SKIP_BLOCK_SIZE]=args[STR_S_SKIP_BLOCK_SIZE].to_i
args[STR_S_SKIP_BLOCK_NUMBER]=args[STR_S_SKIP_BLOCK_NUMBER].to_i
#目标文件起始跳过块的大小，没有的就和block_size一样
if args[STR_T_SKIP_BLOCK_NUMBER]>0 and args[STR_T_SKIP_BLOCK_SIZE]<0
  args[STR_T_SKIP_BLOCK_SIZE]=args[STR_BLOCK_SIZE]
end
#源文件起始跳过块的大小，没有的就和block_size一样
if args[STR_S_SKIP_BLOCK_NUMBER]>0 and args[STR_S_SKIP_BLOCK_SIZE]<0
  args[STR_S_SKIP_BLOCK_SIZE]=args[STR_BLOCK_SIZE]
end
if args[STR_IS_TEST]=='false'
  args[STR_IS_TEST]=false
else
  args[STR_IS_TEST]=true
end
#参数检查
#注意："hello".to_i             #=> 0
(puts "target file can't null!";exit) if args[STR_T_FILE]==nil
(puts "source file can't null!";exit) if args[STR_S_FILE]==nil
(puts "block size must large than 512 !";exit) if args[STR_BLOCK_SIZE]<512
(puts "block number must large than 0 !";exit) if args[STR_BLOCK_NUMBER]<1
(puts "target block size must large than 512 !";exit) if args[STR_T_SKIP_BLOCK_SIZE]<512
(puts "target block number must large than 0 !";exit) if args[STR_T_SKIP_BLOCK_NUMBER]<1
(puts "source block size must large than 512 !";exit) if args[STR_S_SKIP_BLOCK_SIZE]<512
(puts "source block number must large than 0 !";exit) if args[STR_S_SKIP_BLOCK_NUMBER]<1


if args[STR_IS_TEST]
  require 'pp'
  puts 'version 1.01 2007-04-26 by Colin J'
  pp args
  start_time = Time.now
  puts 'replace start!!!'
end 
file_place(args[STR_T_FILE],args[STR_S_FILE],
    args[STR_BLOCK_SIZE],args[STR_BLOCK_NUMBER],
    args[STR_T_SKIP_BLOCK_SIZE],args[STR_T_SKIP_BLOCK_NUMBER],
    args[STR_S_SKIP_BLOCK_SIZE],args[STR_S_SKIP_BLOCK_NUMBER])
if args[STR_IS_TEST]
  end_time = Time.now
  puts "#{end_time-start_time} seconds"
  puts 'replace end!!!'
end 


