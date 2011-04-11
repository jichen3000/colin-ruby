require 'rawio'
require 'colin_helper_mini'
require "ora_log_domains"
filename = '/dev/vgcss_app/rlvdatafile'
puts "RawIO::exist?"+RawIO::exist?(filename).to_s
f = RawIO::RawFile.new
f.open(filename,'r+b')
f.close
f = nil

p "file re open!"
f = RawIO::RawFile.new
f.open(filename,'r+b')
ab = f.read(8*1024)
10.times do |i|
	puts i
	block = f.read(8*1024)
	ReadBlockService.set_cur_block(block)
#	puts ColinHelper.barr2str16(block)
  str = ReadBlockService.r_b(4,4)
	puts ColinHelper.barr2str16(str) 
	f.seek(8*1024,IO::SEEK_CUR)
end
str = ab[4..8]
puts ColinHelper.barr2str16(str) 
f.close
f = nil
sleep(10)
puts "ok"