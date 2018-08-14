require "logger"

class MultiIO
  def initialize(*targets)
     @targets = targets
  end

  def write(*args)
    @targets.each {|t| t.write(*args)}
  end

  def close
    @targets.each(&:close)
  end
end

filename = "test.log"
# Logger.new(name, shift_age = 7, shift_size = 1048576)
#logdev: The log device. This is a filename (String) or IO object (typically STDOUT, STDERR, or an open file).
# 文件名
#shift_age:  Number of old log files to keep, or frequency of rotation (daily, weekly or monthly).
# 保存时间
#shift_size: Maximum logfile size (only applies when shift_age is a number).
# 一个log文件的最大size 
# log = Logger.new(STDOUT)
# log = Logger.new(filename, 7, 10485760)
log_file = File.open(filename, "w")
log = Logger.new(MultiIO.new(STDOUT, log_file), 7, 10485760)
log1 = Logger.new("test1.log", 7, 10485760)
# log << Logger.new(filename, 7, 10485760)
#log.set_log(Logger.new(filename, 7, 10485760))
#log.add(filename, 7, 10485760)
#log.level=Logger::DEBUG
5.times do |index|
  log.info("info #{index}")
  log.warn("warn #{index}")
  log.error("error #{index}")
  log1.error("error #{index}")
end

#log.close
p "ok"