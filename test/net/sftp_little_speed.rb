# 问题：使用sftp传输多个小文件时，速度会非常慢。
# 解决方案，使用多线程来起多个连接同时传输。
require 'net/sftp'
def dir_trans(from_dir,to_dir)
  filenames = []
  file_count = 0
  file_size = 0
  Dir.open(from_dir).each do |filename|
    if filename != '.' and filename != '..'
      filenames << filename
      file_size += File.size(File.join(from_dir,filename))
      file_count += 1
    end
  end
  
  start_time = Time.now
  sftp = Net::SFTP.start('172.16.4.200','root', :password => 'root')
  filenames.each do |filename|
    sftp.upload!(File.join(from_dir,filename),File.join(to_dir,filename))
  end
  end_time = Time.now
  p "time: #{end_time - start_time}"
  p "file_count: #{file_count}"
  p "file_size: #{file_size/1024}K"
  sftp.close_channel
end
def dir_trans_mput(from_dir,to_dir,filename)
  file_count = 0
  file_size = 0
  
  start_time = Time.now
  sftp = Net::SFTP.start('172.16.4.200','root', :password => 'root')
  sftp.upload!(File.join(from_dir,filename),File.join(to_dir,filename))
  end_time = Time.now
  p "time: #{end_time - start_time}"
  p "file_count: #{file_count}"
  p "file_size: #{file_size/1024}K"
  sftp.close_channel
end
# 使用多线程来加快速度
# 如果多个线程使用同一个sftp会报错，当主线程调用时sftp.close_channel，即使用join也没有用。
def dir_trans_with_thread(from_dir,to_dir)
  filenames = []
  sftp_arr = []
  file_count = 0
  file_size = 0
  thread_count = 8
  # 创建多个文件数组和sftp连接。
  thread_count.times do
    filenames << []
    sftp_arr << Net::SFTP.start('172.16.4.200','root', :password => 'root')
  end
  Dir.open(from_dir).each do |filename|
    if filename != '.' and filename != '..'
      index = file_count%4 
      filenames[index] << filename
        
      file_size += File.size(File.join(from_dir,filename))
      file_count += 1
    end
  end
#  p filenames
  t_arr = []
  start_time = Time.now
#  sftp = Net::SFTP.start('172.16.4.200','root', :password => 'root')
  index = 0
  filenames.each do |filename_arr|
    # 必须在这里使用一个变量来使用sftp_arr[index]，直接写在下面的thread中会报错
    sftp = sftp_arr[index]
    t = Thread.new do
      filename_arr.each do |filename|
        sftp.upload!(File.join(from_dir,filename),File.join(to_dir,filename))
      end      
    end
    t_arr << t
    index += 1
  end
  t_arr.each do |t|
    t.join 
  end
#  p Thread.list
#  Thread.list do |t|
#    p t
#    t.join 
#  end
  end_time = Time.now
  p "time: #{end_time - start_time}"
  p "file_count: #{file_count}"
  p "file_size: #{file_size/1024}K"
  sftp_arr.each do |sftp|
    sftp.close_channel
  end
end
#sftp = Net::SFTP.start('172.16.4.28','dbra', :password => 'mcdbra')
#p "start"
#sftp.upload!("D:/down/linux/lfslivecd-x86-6.3-r2160.iso",'/home/colin/lfslivecd-x86-6.3-r2160.iso')

#p "sftp.closed?:#{sftp.closed?}"
#sftp.close_channel
#p "sftp.closed?:#{sftp.closed?}"
from_dir = "D:/tmp/littles"
to_dir = '/home/colin/littles'
#dir_trans_with_thread(from_dir,to_dir)
dir_trans_mput(from_dir,to_dir,"mcb_1_15500_20090810_161503_0")
#dir_trans(from_dir,to_dir)
puts "ok"