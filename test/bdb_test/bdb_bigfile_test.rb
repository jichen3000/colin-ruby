require 'bdb'
require 'colin_helper'

log_filename = ColinHelper.log_name(File.basename(__FILE__))
is_trunc = false
@@log = ColinHelper.get_log4r_log(log_filename,'test',2,true,is_trunc)

class BackupItem
	class << self
		def get_key(line)
			ol,afn,dba,scn,scn_wrap,seqence,flg,block_count = line.split(" ")
			block_count ||= 1
#			[ol+' '+afn+' '+dba+' '+block_count,scn+' '+scn_wrap+' '+seqence+' '+flg]
			afn+' '+dba+' '+block_count.to_s
		end
	end
end
class DbTest
	class << self
		def perform
			start_time=Time.now
			@@log.info("App Start! time: #{ColinHelper.str_time(start_time)}")
			dt = DbTest.new
			loginfo_filename = 'mcb_20080102_142803.loit'
			db_filename = 'mcb.db'
			dt.set_attrs(loginfo_filename, db_filename)
			@@log.info("loginfo_filename : #{loginfo_filename}")
			@@log.info("db_filename : #{db_filename}")
			
			@@log.info("Write DB start...")
			step_start_time = Time.now
			dt.write_db
		  step_end_time = Time.now
			@@log.info("Write DB end!")
			@@log.info("Through #{(step_end_time-step_start_time).to_f.to_s} seconds!")
			
			@@log.info("Read DB start...")
			step_start_time = Time.now
			dt.read_db
		  step_end_time = Time.now
			@@log.info("Read DB end!")
			@@log.info("Through #{(step_end_time-step_start_time).to_f.to_s} seconds!")
			
			
			
			end_time = Time.now
			@@log.info("App End! time: ColinHelper.str_time(end_time)")
			@@log.info("Through #{(end_time-start_time).to_f.to_s} seconds!")
			@@log.info("")
		end
	end
	def set_attrs(loginfo_filename, db_filename)
		@loginfo_filename = loginfo_filename
		@db_filename = db_filename
		@re_loginfo_filename = "re_"+loginfo_filename
	end
	def write_db
		db = BDB::Btree.create(@db_filename,nil,BDB::CREATE,0644,"set_pagesize" => 1024)
		loginfo_file = File.open(@loginfo_filename,'r')
		
		total_line_count = 0
		loginfo_file.each_line do |line|
			print "=" if total_line_count % 10000 == 0 and total_line_count > 0 
			puts "" if total_line_count % 200000 == 0 and total_line_count > 0 
			db.put(BackupItem.get_key(line),line)
			total_line_count += 1
		end
		puts ""
		@@log.info("total line count : #{total_line_count}")
		@@log.info("total record count : #{db.size}")
		
		loginfo_file.close
		db.close
	end
	def read_db
		db = BDB::Btree.create(@db_filename,nil,'r',0644,"set_pagesize" => 1024)
		re_loginfo_file = File.open(@re_loginfo_filename,'w')
		
		total_line_count = 0
		db.each_value do |line|
			print "=" if total_line_count % 10000 == 0 and total_line_count > 0 
			puts "" if total_line_count % 200000 == 0 and total_line_count > 0 
			re_loginfo_file << line
			total_line_count += 1
		end
		puts		
		re_loginfo_file.close
		db.close
	end
end

DbTest.perform
puts "ok"
