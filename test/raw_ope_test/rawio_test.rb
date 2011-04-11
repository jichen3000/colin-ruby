require 'rawio'
require 'colin_helper_mini'
def fill_arr(arr,size)
	return if arr.size >= size
	len = size - arr.size
	(len).times do |i|
		arr << "00"
	end
end
	
def file_write(file)
	i_arr = ["2300","4500","9600"]
	fill_arr(i_arr,1024)
	block = i_arr.pack("H2"*i_arr.size)
	puts ColinHelper.barr2str16(block)
	
	file.write(block)
#	puts "wire after start"
#	puts ColinHelper.barr2str16(block)
#	puts "wire after end"
end
#puts "/dev/raw/raw1"
#filename = "/dev/raw/raw15"
filename = '/dev/vg00/rlvtest'
#w_filename = File.join(File.dirname(__FILE__),'ttt01')
#puts w_filename
#w_file = File.new(w_filename,'wb')
puts "RawIO::exist?"+RawIO::exist?(filename).to_s
#begin
	puts RawIO::rawfile?(filename)
#rescue RawIOError => e
#	puts e.message
#end
#puts "/home/colin/rbtest/mc_rbs/test/raw_ope_test/extconf.rb"
#puts RawIO::rawfile?("/home/colin/rbtest/mc_rbs/test/raw_ope_test/extconf.rb")
f = RawIO::RawFile.new
f.open(filename,'r+b')
puts "file path: #{f.path}"
puts "file block_size: #{f.block_size}"
puts "cur pos : "+f.tell.to_s
puts

#puts "seek from cur 4096*4 bytes"
#puts f.seek(4096*4,IO::SEEK_CUR)
#puts "cur pos : "+f.tell.to_s

puts "read 1024 bytes"
block = f.read(1024)
puts ColinHelper.barr2str16(block)
puts "cur pos : "+f.tell.to_s
#w_file.write(block)
#w_file.close;

puts "seek from cur 1024 bytes"
puts f.seek(1024,IO::SEEK_CUR)
puts "cur pos : "+f.tell.to_s

puts "read 1024 bytes"
block = f.read(1024)
puts ColinHelper.barr2str16(block)
puts "cur pos : "+f.tell.to_s

puts "seek from cur -1024 bytes"
puts f.seek(-1024,IO::SEEK_CUR)
puts "cur pos : "+f.tell.to_s

puts "write 1024 bytes"
file_write(f)
puts "cur pos : "+f.tell.to_s

puts "seek from cur -1024 bytes"
puts f.seek(-1024,IO::SEEK_CUR)
puts "cur pos : "+f.tell.to_s

puts "read 1024 bytes"
block = f.read(1024)
puts ColinHelper.barr2str16(block)
puts "cur pos : "+f.tell.to_s

#puts "big file test1 {{"
#tt = 1024*1024*1024*4
#puts "seek from cur #{tt/(1024*1024*1024)}G(#{tt}) bytes"
#puts f.seek(tt,IO::SEEK_CUR)
#puts "cur pos : "+f.tell.to_s
#
#puts "read 512 bytes"
#block = f.read(512)
#puts ColinHelper.barr2str16(block)
#puts "cur pos : "+f.tell.to_s
#
#puts "write 512 bytes"
#file_write(f)
#puts "cur pos : "+f.tell.to_s
#
#puts "seek from cur -512 bytes"
#puts f.seek(-512,IO::SEEK_CUR)
#puts "cur pos : "+f.tell.to_s
#
#puts "read 512 bytes"
#block = f.read(512)
#puts ColinHelper.barr2str16(block)
#puts "cur pos : "+f.tell.to_s
#
#puts "}} big file test1"


#
##puts "pre write pos: "+f.tell.to_s
##puts "pre write pos: "+f.tell.to_s
#puts file_write(f)
##puts ColinHelper.barr2str16(f.read(8))
##puts "after write pos: "+f.tell.to_s
#puts f.seek(-512,IO::SEEK_CUR)
#block = f.read(8)
#puts ColinHelper.barr2str16(block)

#f.close
puts "close file"
f.close

## reopen 和 IO::SEEK_SET
#f = RawIO::RawFile.new
#f.open(filename,'rb')
#puts "file path: #{f.path}"
#puts "file block_size: #{f.block_size}"
#puts
#
#puts "seek from set 4096*4 bytes"
#puts f.seek(4096*4,IO::SEEK_SET)
#puts "cur pos : "+f.tell.to_s
#
#puts "read 512 bytes"
#block = f.read(512)
#puts ColinHelper.barr2str16(block)
#puts "cur pos : "+f.tell.to_s
#
#puts "close file"
#f.close

puts "ok"
