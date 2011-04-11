require 'multi_file'

require 'colin_helper'
def fill_arr(arr,size)
	return if arr.size >= size
	len = size - arr.size
	(len).times do |i|
		arr << "00"
	end
end
	
def file_write(file)
	i_arr = ["2300","4500","9600"]
	fill_arr(i_arr,512)
	block = i_arr.pack("H2"*i_arr.size)
	puts ColinHelper.barr2str16(block)
	
	file.write(block)
end

#puts "/dev/raw/raw1"
#filename = "/dev/raw/raw14"
filename = "/oracle/colin/rbtest/mc_rbs/raw_ope_test/1_157.dbf"
puts "MultiFile.exist?"+MultiFile.exist?(filename).to_s
begin
	puts "MultiFile.rawfile?"+MultiFile.rawfile?(filename).to_s
rescue RawIOError => e
	puts e.message
end
#puts "/home/colin/rbtest/mc_rbs/test/raw_ope_test/extconf.rb"
#puts RawIO::rawfile?("/home/colin/rbtest/mc_rbs/test/raw_ope_test/extconf.rb")
f = MultiFile.new(filename,'rb+')
puts "file path: #{f.path}"
puts
puts "read 512 bytes"
block = f.read(512)
puts ColinHelper.barr2str16(block)
puts "cur pos : "+f.tell.to_s

puts "seek from cur 512 bytes"
puts f.seek(512,IO::SEEK_CUR)
puts "cur pos : "+f.tell.to_s

puts "read 512 bytes"
block = f.read(512)
puts ColinHelper.barr2str16(block)
puts "cur pos : "+f.tell.to_s

puts "seek from cur -512 bytes"
puts f.seek(-512,IO::SEEK_CUR)
puts "cur pos : "+f.tell.to_s

puts "write 512 bytes"
file_write(f)
puts "cur pos : "+f.tell.to_s

puts "seek from cur 512 bytes"
puts f.seek(512,IO::SEEK_CUR)
puts "cur pos : "+f.tell.to_s

puts "read 512 bytes"
block = f.read(512)
puts ColinHelper.barr2str16(block)
puts "cur pos : "+f.tell.to_s

