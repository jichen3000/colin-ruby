require 'logger'

class MultiLogger

  def initialize(args={})
    @loggers = []

    Array(args[:loggers]).each { |logger| add_logger(logger) }
  end

  def add_logger(logger)
    @loggers << logger
  end

  def close
    @loggers.map(&:close)
  end

  def add(level, *args)
    @loggers.each { |logger| logger.add(level, args) }
  end

  Logger::Severity.constants.each do |level|
    define_method(level.downcase) do |*args|
      @loggers.each { |logger| logger.send(level.downcase, *args) }
    end

    define_method("#{ level.downcase }?".to_sym) do
      @level <= Logger::Severity.const_get(level)
    end
  end
end

# debug: Logger::Severity::DEBUG,
# info: Logger::Severity::INFO,
# warn: Logger::Severity::WARN,
# fatal: Logger::Severity::FATAL,
# error: Logger::Severity::ERROR

$cur_dir = File.dirname(__FILE__)
log_2_path = File.join($cur_dir,"test2.log")
log_3_path = File.join($cur_dir,"test3.log")

log_1 = Logger.new(STDOUT)
log_1.level = Logger::DEBUG
log_2 = Logger.new(File.open(log_2_path,'w'))
log_2.level = Logger::INFO
log_3 = Logger.new(File.open(log_3_path,'w'))
log_3.level = Logger::ERROR

# STDOUT.sync = true
# log_file.sync = true


multi_logger = MultiLogger.new(:loggers => log_1)
multi_logger.add_logger(log_2)
multi_logger.add_logger(log_3)

multi_logger.debug('debug happened.')
multi_logger.info('Something interesting happened.')
multi_logger.error('error happened.')
