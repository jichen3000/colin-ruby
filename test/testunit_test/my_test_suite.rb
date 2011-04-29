require 'test/unit/testsuite'
require File.join(File.dirname(__FILE__),'setup_times')
class MyTestSuite < Test::Unit::TestSuite
  def self.suite
    self << TestSetupTimes.suite
  end
  def setup
    puts "suite setup"
  end
  def teardown
    puts "suite teardown"
  end
  def run(*args)
    setup
    super
    teardown
  end
  
end