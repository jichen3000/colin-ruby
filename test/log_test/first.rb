# 这是关于日志在多个源文件中的穿透问题。


require 'log4r'
require 'second'

#def get_log4r_log(filename,log_name,log_level=nil,is_stdout=false,is_trunc=false)
#	log = Log4r::Logger.new(log_name)
#	log.outputters = Log4r::Outputter.stdout if is_stdout
#	
#	log.add(Log4r::FileOutputter.new('file',
#		{:filename => filename, :trunc => is_trunc}))
#	log_level ||= Log4r::INFO
#	log.level = log_level
#	log
#end
#@@log = get_log4r_log('log_test.log',
#	'lt', 2, true, true)
@@log = nil	
class First
	def self.ope
		10.times do |i|
#			@@log.info("First NO.#{i} start")
#			Second.ope
#			@@log.info("First NO.#{i} end")
			@log = get_log4r_log('log_test.log',
				'lt', 2, true, true)
			@log.info("First NO.#{i} start")
			Second.ope
			@log.info("First NO.#{i} end")
		end
	end
end

First.ope
#@@log.info "ok"