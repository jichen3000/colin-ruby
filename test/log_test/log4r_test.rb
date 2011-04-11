require 'log4r'
#include Log4r

mylog = Log4r::Logger.new('mylog')
#mylog.outputters = Outputter.stdout
filename = File.join(File.dirname(__FILE__),'test.log')
#if File.exist?(filename)
#  File.new(filename,'r').close
#end
#puts __FILE__
#puts File.dirname(__FILE__)
#puts filename
#mylog.outputters = [FileOutputter.new('mylog',:filename=>filename),Outputter.stdout]
mylog.outputters = Log4r::FileOutputter.new('mylog',{:filename=>filename,:trunc=>false})
mylog.add(Log4r::Outputter.stdout)
mylog.info(Time.now)
def do_log(log)
  log.debug "This is message with level DEBUG"
  log.info "This is message with level INFO"
  log.warn "This is message with level WARN"
  log.error "This is message with level ERROR"
  log.fatal "This is message with level FATAL"
end
#mylog.additive = true
do_log(mylog)

mylog.level = Log4r::WARN

do_log(mylog)
