require 'colin_helper'
def only_read_file(file_name,block_size)
    start_time=Time.now
    puts( 'App Start! time: '+ColinHelper.str_time(start_time))
  file = File.new(file_name,'rb')
  i = 0
  while !file.eof
    block = file.read(block_size)
#    block[0..block_size-1]
    i += 1
  end
    end_time=Time.now
    puts( 'App End! time: '+ColinHelper.str_time(end_time))
    puts( 'Through '+(end_time-start_time).to_f.to_s+' seconds!')
    puts(i)
    file.close if file != nil
end

file_name = 'D:\work\railsws\mc_rbs\read_ora_log\1_37.dbf'
only_read_file(file_name,512)
#only_read_file(file_name,1024*1024)