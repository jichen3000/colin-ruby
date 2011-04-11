require 'log4r'
require 'test/unit'
require 'rollingoverfileoutputter'

class TestLog4r < Test::Unit::TestCase
  def test_maxsize
    mylog = Log4r::Logger.new('mylog')
    filename = File.join(File.dirname(__FILE__),'maxsize.log')
    mylog.outputters = Log4r::RollingOverFileOutputter.new('mylog',
      {:filename=>filename, :trunc=>false, :maxsize=>256, :filemaxcount=>4})
    mylog.add(Log4r::Outputter.stdout)
    60.times do |i|
      mylog.info(Time.now)
      mylog.info(i.to_s)
    end
  end
  def test_maxtime
#    mylog = Log4r::Logger.new('mylog')
#    filename = File.join(File.dirname(__FILE__),'maxsize.log')
#    mylog.outputters = Log4r::RollingOverFileOutputter.new('mylog',
#      {:filename=>filename, :trunc=>false, :maxtime=>1, :filemaxcount=>4})
##      {:filename=>filename, :trunc=>true, :maxsize=>256})
#    mylog.add(Log4r::Outputter.stdout)
#    50.times do |i|
#      mylog.info(Time.now)
#      mylog.info(i.to_s)
#      sleep(0.1)
#    end
  end
end
