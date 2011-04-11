require 'test/unit'
require File.join(File.dirname(__FILE__),'sub_add')

class SubAddTest < Test::Unit::TestCase
  def setup
  end
  def test_get_block
    sf = SubFile.new(File.join(File.dirname(__FILE__),'test.str'))
    assert_equal(["1\n", "00:00:01,222 --> 00:00:02,333\n", "第一行\n"], sf.get_block)
    assert_equal(["2\n", "00:00:11,222 --> 00:00:12,333\n", "第二行\n", "第二行 two\n"], sf.get_block)
    sf.get_block
    assert_nil(sf.get_block)
    assert(!sf.get_block)
      
  end
  def test_join
#    sf1 = SubFile.new(File.join(File.dirname(__FILE__),'test.str'))    
#    sf2 = SubFile.new(File.join(File.dirname(__FILE__),'test1.str'))
#    sf1.add(sf2,)    
  end
  def test_timestr
    assert_equal("00:00:41,777",
      SubBlock.timestr_add_usec("00:00:11,222",SubBlock.timestr_to_usec('00:00:30,555')))
    assert_equal("00:00:19,333",
      SubBlock.timestr_div_usec('00:00:30,555',SubBlock.timestr_to_usec("00:00:11,222")))
  end
  def test_to_usec
    assert_equal(3661111,SubBlock.arr_to_usec([1,1,1,111]))
    assert_equal([1,1,1,111],SubBlock.usec_to_arr(3661111))
      
    assert_equal(3661001,SubBlock.timestr_to_usec("01:01:01,001"))
    assert_equal(1222,SubBlock.timestr_to_usec("00:00:01,222"))
    assert_equal("01:01:01,001",SubBlock.usec_to_timestr(3661001))
    assert_equal("00:00:01,222",SubBlock.usec_to_timestr(1222))
  end
  def test_sub_block
    block = ["2\n", "00:00:11,222 --> 00:00:12,333\n", "第二行\n", "第二行 two\n"]
    sub_block = SubBlock.new(block)
    assert_equal(2,sub_block.index)
    assert_equal("00:00:11,222",sub_block.start_time_str)
    assert_equal("00:00:12,333",sub_block.end_time_str)
    assert_equal(block,sub_block.content)
    
    usec = SubBlock.timestr_to_usec('00:00:30,555')
    sub_block.change_time('+', usec)
    assert_equal("00:00:41,777",sub_block.start_time_str)
    assert_equal("00:00:42,888",sub_block.end_time_str)
    
    sub_block.change_time('-', usec)
    assert_equal("00:00:11,222",sub_block.start_time_str)
    assert_equal("00:00:12,333",sub_block.end_time_str)
    
    sub_block.change_index('+', 10)
    assert_equal(12,sub_block.index)
    sub_block.change_index('-', 10)
    assert_equal(2,sub_block.index)
    
    assert_equal(block,sub_block.get_new_block)
  end
end
