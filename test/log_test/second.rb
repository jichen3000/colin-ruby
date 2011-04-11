require 'third'
require 'log4r'

def get_log4r_log(filename,log_name,log_level=nil,is_stdout=false,is_trunc=false)
	log = Log4r::Logger.new(log_name)
	log.outputters = Log4r::Outputter.stdout if is_stdout
	
	log.add(Log4r::FileOutputter.new('file',
		{:filename => filename, :trunc => is_trunc}))
	log_level ||= Log4r::INFO
	log.level = log_level
	log
end
class Second
	def self.ope
		@@log = get_log4r_log('log_test2.log',
			'lt s', 2, true, true)
		5.times do |i|
			@@log.info("	Second NO.#{i} start")
			Third.ope
			@@log.info("	Second NO.#{i} end")
		end
	end
end