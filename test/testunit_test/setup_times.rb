require 'test/unit'

class TestSetupTimes < Test::Unit::TestCase
  def setup
    puts "setup"
  end
  def teardown
    puts "teardown"
  end
  def test_one
    puts "one"
    assert(true);
  end
  def test_two
    puts "two"
    assert(true);
  end
end