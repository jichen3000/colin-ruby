require 'test/unit'
require File.join(File.dirname(__FILE__),'sub_add')
class SubJoinTest < Test::Unit::TestCase
  def setup
    @first_filename = File.join(File.dirname(__FILE__),'test.str')
    @second_filename = File.join(File.dirname(__FILE__),'test1.str')
    @new_filename = File.join(File.dirname(__FILE__),'new_test.str')
  end
  def test_get_first_last_index
    sj = SubJoin.new(@first_filename,@new_filename)
    assert_equal(3,sj.get_first_last_index)
  end
  def test_add_sub_file
    sj = SubJoin.new(@first_filename,@new_filename)
    sj.add_sub_file(@second_filename,'00:33:00,001')
    assert_equal(1,sj.other_sub_files.size)
    assert_equal(1980001,sj.other_sub_files.last.ope_object)
  end
  def test_add_new_file
    sj = SubJoin.new(@first_filename,@new_filename)
    assert_equal(File.size(@first_filename),File.size(@new_filename))
  end
  def test_perform
    sj = SubJoin.new(@first_filename,@new_filename)
    sj.add_sub_file(@second_filename,'00:33:00,001')
    sj.perform
  end
end
