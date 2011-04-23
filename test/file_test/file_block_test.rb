# 测试读取和写入block的时间

@@data_filename = 'D:\work\testdata\datafile\users02.dbf'
@@t_filename = 'D:\work\testdata\datafile\block.test'
@@tone_filename = 'D:\work\testdata\datafile\blockone.test'

@@total_count = 100000
@@block_size = 1024
def read_blocks
	puts "read_blocks start.."
	start_time = Time.now
	data_file = File.open(@@data_filename,'r')
	@@total_count.times do |index|
		block = data_file.read(@@block_size)
	end
	data_file.close
	end_time = Time.now
	puts "read_blocks end."
	puts "Throught #{(end_time-start_time).to_f.to_s} seconds!!" 
end
def read_blocks_one
	puts "read_blocks_one start.."
	start_time = Time.now
	data_file = File.open(@@data_filename,'r')
	block = data_file.read(@@block_size * @@total_count)
	data_file.close
	end_time = Time.now
	puts "read_blocks_one end."
	puts "Throught #{(end_time-start_time).to_f.to_s} seconds!!" 
end

def write_blocks
	puts "write_blocks start.."
	start_time = Time.now
	data_file = File.open(@@data_filename,'r')
	t_file = File.open(@@t_filename,'w')
	@@total_count.times do |index|
		block = data_file.read(@@block_size)
		t_file.write(block)
	end
	t_file.close
	data_file.close
	end_time = Time.now
	puts "write_blocks end."
	puts "Throught #{(end_time-start_time).to_f.to_s} seconds!!" 
end

def write_blocks_one
	puts "write_blocks_one start.."
	start_time = Time.now
	data_file = File.open(@@data_filename,'r')
	tone_file = File.open(@@tone_filename,'w')
	block = data_file.read(@@block_size)
	(1000).times do |index|
		block += data_file.read(@@block_size)
	end
	tone_file.write(block)
	tone_file.close
	data_file.close
	end_time = Time.now
	puts "write_blocks_one end."
	puts "Throught #{(end_time-start_time).to_f.to_s} seconds!!" 
end

#read_blocks
#read_blocks_one
#write_blocks
write_blocks_one
puts "ok"