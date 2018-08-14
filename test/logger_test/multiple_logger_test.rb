# http://stackoverflow.com/questions/917566/ruby-share-logger-instance-among-module-classes
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

def create_logger(filename)
    # filename="out_#{filename_time}.log"
    log_file = File.open(filename, "w")
    STDOUT.sync = true
    log_file.sync = true
    the_logger = Logger.new(MultiIO.new(STDOUT, log_file))
    return the_logger
end

$cur_dir = File.dirname(__FILE__)
log_path = File.join($cur_dir,"replayer.log")

$logger = create_logger("replayer.log")
