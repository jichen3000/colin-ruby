require 'multi_file'
#require 'ora_log_domains'
require 'colin_helper'

class DataFile
	def initialize(*arg)
		if arg.size == 1
			attr_arr = arg[0].split(' ')
			@afn = attr_arr[0].to_i
			@rfn = attr_arr[1].to_i
#			@file_name = String.new(attr_arr[2])
#			puts attr_arr[2].class
			@file_name = attr_arr[2]
#			@file_name = '/dev/vgcss_app/rlvdatafile'
		elsif arg.size == 2
			@afn = arg[0]
			@rfn = arg[1]
		end
		
		# test
		@block_size = 512
		@block_size = 1024
	end
	# 对于数据文件的第一读取，读取之后会关闭。
	# 但是对于oracle头数据
	def first_read(is_write=false)
		puts @file_name
		@file = MultiFile.new(@file_name,'rb')
		puts "path : #{@file.path}"
		# test
#		@@log.info("#{@file_name} is opened!!") 
		@is_file_closed = false
				
		# 读取第一个文件块
		# 日志文件操作系统块格式块
#		block = @file.read(@block_size)
#		ReadBlockService.set_cur_block(block)
#		@ol_file_header = OLFileHeader.new(self)
#		@file.seek(@block_size-block.size,IO::SEEK_CUR)
#		block = nil
#		# 读取第二个文件块
#		# 日志文件Oracle文件头格式块
#		# 当前数据文件读取完后，将此块放在备份的最后
#		@ora_header_block = @file.read(@block_size)
#		#test
##		puts ColinHelper.barr2str16(@ora_header_block,512)
#		
#		# 读取Oracle文件头信息
#		@header_item=OLBackupItem.create_from_oraheader_block(@ora_header_block,@afn)
		#test
#		puts @header_item
		# 已经读取了二个块，从第三个块开始
#		@cur_block_no = 2
		@file.close
		@file = nil
#		@is_file_closed = true
		# test
#		@@log.info("#{@file_name} is closed!!") 
#		@cur_block_no
	end
end
#filename = "/dev/vgcss_app/rlvdatafile"
#puts "MultiFile.exist?"+MultiFile.exist?(filename).to_s
#f = MultiFile.new(filename,'rb+')
#f.close
#f = nil
#ConfigValues.set_basic_block_size(HP_OS)
item = '40 40 /dev/vgcss_app/rlvdatafile'
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

