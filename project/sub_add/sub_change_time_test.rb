require 'test/unit'
require File.join(File.dirname(__FILE__),'sub_add')
class SubChangeTimeTest < Test::Unit::TestCase
  def setup
    @first_filename = File.join(File.dirname(__FILE__),'test.str')
    @new_filename = File.join(File.dirname(__FILE__),'new_test.str')
  end
  def test_perform
    sct = SubChangeTime.new(@first_filename,@new_filename)
    sct.perform("+",'00:33:00,001')
  end
end
