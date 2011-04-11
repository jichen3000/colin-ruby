#ENV["MEGATRUST_DAEMON_HOME"] = File.join(File.dirname(__FILE__),"..")
#require File.join(ENV["MEGATRUST_DAEMON_HOME"],"config/enviroment")
#$logger = DeamonInitializer.get_logger('logger_test')
#$logger.info("mmmm")
require 'active_record'
#require 'logger'
#require 'logger'
filename = File.join(File.dirname(__FILE__),"../logs","logger_test.log")
log = Logger.new(filename, 7, 10485760)
log.formatter = Logger::Formatter.new()
log.info("cccc")

p "ok"
