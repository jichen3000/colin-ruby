# oracle datafile's header transform.
# 

require 'colin_helper'


FIRST_SIZE = 512
HP2IBM = 'HP2IBM'
IBM2HP = 'IBM2HP'
class TransDatafileService
	def initialize(ope_type,filename,is_reverse,is_test)
		@log = ColinHelper.get_log4r_log(ColinHelper.log_name(__FILE__),
			'tds',2, is_test, false)
		@filename = filename
		@is_reverse = is_reverse
		@is_test = is_test
		@ope_type = ope_type.upcase

		
		@datablock_arr = Array.new
		if @ope_type == IBM2HP
			@datablock_arr << Datablock.new(300,176,48)
			@datablock_arr << Datablock.new(472,224,133)
		elsif  @ope_type == HP2IBM
			@datablock_arr << Datablock.new(176,300,48)
			@datablock_arr << Datablock.new(224,472,133)
		else
			@log.error("Transform type is not support!")
			@log.info("Support now is #{IBM2HP} , #{HP2IBM}")
			exit
		end	
		#test
#		@datablock_arr << Datablock.new(0,16,4)
#		@datablock_arr << Datablock.new(6*16,7*16,8)
	end
	def self.perform(ope_type,filename,is_reverse=true,is_test=true)
		tds = TransDatafileService.new(ope_type,filename,is_reverse,is_test)
		tds.dowith
	end
	def dowith
		start_time = Time.now
		@log.info("TransDatafileService App start! time : " + ColinHelper.str_time(start_time))
		
		@log.info("Transform datafile name: #{@filename}!")
		@log.info("Transform datafile type: #{@ope_type}!")
		
		
		file = File.new(@filename,'r+b')
		read_block_size(file.read(FIRST_SIZE))
		@log.info("Block size: #{@block_size}!")
		file.seek(@block_size - FIRST_SIZE,IO::SEEK_CUR)
		#test
#		@block_size = FIRST_SIZE
#		file.read(@block_size)
		
		@log.info("Total #{@datablock_arr.size} items need do with!")
		second_block = file.read(@block_size)
		
		@datablock_arr.each do |item|
			@log.info("source block offset: #{item.source_offset}, "+ 
				"target block offset: #{item.target_offset}, size: #{item.size}")
#			source_block = second_block[item.source_offset,item.size]
#			target_block = second_block[item.target_offset,item.size]
#			second_block[item.source_offset,item.size] = target_block
#			second_block[item.target_offset,item.size] = source_block
			second_block[item.target_offset,item.size] = 
					second_block[item.source_offset,item.size] 
#			puts ColinHelper.barr2str16(second_block[item.target_offset,item.size])
#			puts ColinHelper.barr2str16(second_block[item.source_offset,item.size])
		end
		
		#write return
		file.seek(-@block_size, IO::SEEK_CUR)
		file.write(second_block)
		
		file.close if file
		
		end_time = Time.now
		@log.info("TransDatafileService App end! time : " + ColinHelper.str_time(end_time))
		@log.info("Through #{(end_time-start_time).to_f.to_s} seconds.")
		@log.info("")
	end
		
	def read_block_size(block)
		if @is_reverse
			@block_size = block[4..7].reverse
		else
			@block_size = block[4..7]
		end
		@block_size = ColinHelper.barr2int(@block_size)
	end
end

class Datablock
	attr_reader :source_offset, :target_offset, :size
	def initialize(source_offset,target_offset,size)
		@source_offset = source_offset
		@target_offset = target_offset
		@size = size
	end
end

ope_type = IBM2HP
#ope_type = ''
filename = 'D:\work\testdata\datafile\t1.dbf.bak'
is_reverse=true
is_test=true
i = 0
ope_type = ARGV[i].upcase if ARGV.size > i
i += 1
filename = ARGV[i] if ARGV.size > i
i += 1
is_reverse = ARGV[i] if ARGV.size > i
i += 1
is_test = ARGV[i] if ARGV.size > i

TransDatafileService.perform(ope_type,filename,is_reverse,is_test)
