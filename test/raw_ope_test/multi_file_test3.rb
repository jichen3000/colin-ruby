require 'multi_file'
require 'colin_helper'

class DataFile
	def initialize(filename)
		@file_name = filename
	end
	def first_read()
		puts @file_name
		@file = MultiFile.new(@file_name,'rb')
		block = @file.read(8192)
		
		@file.close
	end
end
#filename = "/dev/vgcss_app/rlvdatafile"
#puts "MultiFile.exist?"+MultiFile.exist?(filename).to_s
#f = MultiFile.new(filename,'rb+')
#f.close
#f = nil
#ConfigValues.set_basic_block_size(HP_OS)
item = '/dev/vgcss_app/rlvdatafile'
i=DataFile.new(item)
i.first_read

#puts 're open'
#f = MultiFile.new(filename,'rb+')
#
#ab = f.read(8*1024)
#10.times do |i|
#	puts i
#	block = f.read(8*1024)
#	ReadBlockService.set_cur_block(block)
##	puts ColinHelper.barr2str16(block)
#  str = ReadBlockService.r_b(4,4)
#	puts ColinHelper.barr2str16(str) 
#	f.seek(8*1024,IO::SEEK_CUR)
#end
#f.close
#f = nil
#puts "last"
#ReadBlockService.set_cur_block(ab)
#str = ReadBlockService.r_b(4,4)
#puts ColinHelper.barr2str16(str) 

puts 'ok'

