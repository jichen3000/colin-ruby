require 'test/unit'

class Colin
  def simple
    'simple'
  end
  def self.error
    raise(ColinError.new('mmmm'),"This is a error!")
  end
end
class ColinError  < Exception
  def initialize(msg)
    super(msg)
  end
end
class TestColin < Test::Unit::TestCase
  def test_simple
    # assert,方法的最后一个参数为可以选择的信息，当出错时会打印。
    c = Colin.new
    assert('simple'==c.simple)
    assert_nil(nil)
    assert('simple1'==c.simple,"will failure,colin!")
    # after test failure, method will stop!
    p "ok"
  end
  def test_other
    assert_nil(nil)
    assert_not_nil('')
    assert_equal('','')
    # the equivalent of calling the instance_of? Ruby method.
    assert_instance_of(String,'')
    # the equivalent of calling the kind_of? Ruby method.
    assert_kind_of(String,'')
    assert_respond_to('', :upcase)
    # assert_no_match
    assert_match(/this/,'this')
    # compare object_id
    # assert_not_same
    assert_same(:this, :this)
    
    assert_operator(2, :>, 1)
    
    assert_throws :awesome do
      throw :awesome 
    end
    c = Colin.new
    assert_send([c, :simple])
  end
  def test_delta
    # 前两个值的差，是否在第三个值的范围以内。
    assert_in_delta(0.6,0.51,0.1)
  end
  def test_raise
    # assert_nothing_raised
    # 执行块的内容引发异常, 若该异常属于expected_exception_klass类则pass
    assert_raise(ColinError) do 
      Colin.error
    end
  end
  def test_flunk
    # test will stop execution
    flunk("flunk............")    
  end
end