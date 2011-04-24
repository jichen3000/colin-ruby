# 使用oralce的plsql过程的测试。

require 'oci8'
require 'colin_helper'

log_filename = ColinHelper.log_name(File.basename(__FILE__))
is_trunc = false
@@log = ColinHelper.get_log4r_log(log_filename,'opt',2,true,is_trunc)

class OraclePlsqlTest
	class << self
		def perform
			start_time=Time.now
			@@log.info("App Start! time: #{ColinHelper.str_time(start_time)}")
			
			opt = OraclePlsqlTest.new
			opt.test
			
			
			
			end_time = Time.now
			@@log.info("App End! time: #{ColinHelper.str_time(end_time)}")
			@@log.info("Through #{(end_time-start_time).to_f.to_s} seconds!")
			@@log.info("")
			
			
		end
	end
	def test
		ors = 'mc_backup/mc_dbra@drb'
		in_dir = '/oracle/mc-colin/test'
		in_filenames = 'mcb_20080104_112106.loit'
		out_dir = in_dir
		out_filename = 're_'+in_filenames
		@@log.info("ors : #{ors}")
		@@log.info("in_dir : #{in_dir}")
		@@log.info("in_dir : #{in_dir}")
		@@log.info("in_filenames : #{in_filenames}")
		@@log.info("out_dir : #{out_dir}")
		@@log.info("out_filename : #{out_filename}")
		conn = OCI8.new(ors)
		sql = "begin replace_file('#{in_dir}','#{in_filenames}','#{out_dir}','#{out_filename}'); end;"
		@@log.info("sql : #{sql}")
		conn.exec(sql)
		conn.logoff
	end
end

OraclePlsqlTest.perform
