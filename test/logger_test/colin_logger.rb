require 'logger'
class Logger
  class Formatter
    Format1    =   "%s[%s#%d]%s: %s\n"
    def call(severity, time, progname, msg)
      Format1 % [severity[0..0], format_datetime(time), $$,  progname,
        msg2str(msg)]
    end
    private
  
      def format_datetime(time)
        if @datetime_format.nil?
          time.strftime("%Y-%m-%dT%H:%M:%S.") << "%06d " % time.usec
        else
          time.strftime(@datetime_format) << time.usec.to_s[0..2]
        end
      end
  end
end
class ColinLogger < Logger
#  Logger::Formatter::Format    =   "%s, [%s#%d] %5s  %s: %s\n"
  def initialize(logdev, shift_age = 0, shift_size = 1048576, is_print=false)
    @is_print = is_print
    super(logdev, shift_age, shift_size)
    @level = Logger::INFO
    self.datetime_format = '%m-%d %H:%M:%S.' 
  end
  def info(msg,&block)
    puts msg if @is_print && info?
    super
  end
  def debug(msg,&block)
    puts msg if @is_print && debug?
    super
  end
  def error(msg,&block)
    puts msg if @is_print && error?
    super
  end
  def fatal(msg,&block)
    puts msg if @is_print && fatal?
    super
  end
  def warn(msg,&block)
    puts msg if @is_print && warn?
    super
  end
end
#filename = "test1.log"
#log = ColinLogger.new(filename, 7, 10485760,true)
##p log
##log.level=Logger::ERROR
#p log.level
#p Logger::DEBUG
#p Logger::INFO
#p Logger::WARN
#p Logger::ERROR
#p Logger::FATAL
#log.fatal("my")
#log.info("info")
#log.debug("debug")
#log.warn("warn")
#log.error("error")
#log.fatal("fatal")
#p "ok"