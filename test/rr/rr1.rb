require 'rr'
require 'test/unit'
class User
  def find(id)
    p id
    id
  end
end
class TestRR < Test::Unit::TestCase
  include RR::Adapters::TestUnit
  def test_s1
    my_object = Object.new
    mock(my_object).hello('bob', 'jane').returns('Hello Bob and Jane')
    mock(my_object).hello('mc', 'jane').returns('Hello mc and Jane')
    assert_equal my_object.hello('bob', 'jane'), 'Hello Bob and Jane'
    assert_equal my_object.hello('mc', 'jane'), 'Hello mc and Jane'
    assert_raise(RR::Errors::DoubleNotFoundError) do 
      my_object.hello
    end
  end
  def test_rand
    stub(self).rand(2).returns(3)
    assert_equal rand(2), 3
    assert_equal rand(2), 3
  end
  def test_s2
    my_object = Object.new
    stub(my_object).hello(:jc) {'Hello jc'}
    assert_equal my_object.hello(:jc), 'Hello jc'
  end
  def test_s3
    user = User.new
    # prox 会执行原来的代码，只不过把返回值给替换。
    mock.proxy(user).find(99) {98}
    assert_equal user.find(99), 98
  end
  def test_s4
    user = User.new
    stub.proxy(user).find(99) do |result|
      result = result + 1
    end
    assert_equal user.find(99), 100
  end
  def test_s5
    # block
    script = Object.new
    mock(script) do
      get(1) {true}
      from(3) {3}
    end
    assert_equal script.get(1), true
    assert_equal script.from(3), 3
  end
  def test_s6
    mock.instance_of(User).valid? {false}
    user = User.new
    assert_equal user.valid?, false
  end
  def test_s7
    subject = Object.new
    stub(subject).foo {2}
    p subject.foo(1)
    # 会记录是否已经使用过了。
    assert_received(subject) {|subject| subject.foo(1)}
#    assert_received(subject) {|subject| subject.bar} # This fails
  end
  def test_s8
    object = Object.new
    # 支持级联调用
    stub(object).foo.stub!.bar {:baz}
    object.foo.bar # :baz
    # or
    stub(object).foo {stub!.bar {:baz}}
    object.foo.bar # :baz
    # or
    bar = stub!.bar {:baz}
    stub(object).foo {bar}
    object.foo.bar # :baz
  end
  def test_s9
    object = Object.new
    # anything
    mock(object).foobar(1, anything)
    object.foobar(1, :my_symbol)
    # is_a
    mock(object).foobar(is_a(Time))
    object.foobar(Time.now) 
    
    mock(object).foobar(numeric)
    object.foobar(99)
    
    mock(object).foobar(boolean)
    object.foobar(false)
    # Ranges
    mock(object).foobar(1..10)
    object.foobar(5)   
    # Regexps
    mock(object).foobar(/on/)
    object.foobar("ruby on rails")
    
    mock(object).foobar(hash_including(:red => "#FF0000", :blue => "#0000FF"))
    object.foobar({:red => "#FF0000", :blue => "#0000FF", :green => "#00FF00"})
  end
  def test_s10
    object = Object.new
    # satisfy 满足相关条件
    mock(object).foobar(satisfy {|arg| arg.length == 2})
    object.foobar("xy")
  end
  def test_s11
    object = Object.new
    mock(object).foobar(duck_type(:walk, :talk))
    # 对象要有两个方法:walk, :talk
    arg = Object.new
    def arg.walk; 'waddle'; end
    def arg.talk; 'quack'; end
    object.foobar(arg)
  end
  def test_s12
    object = Object.new
    # any_times, equal stub
    mock(object).method_name(anything).times(any_times) {11}
  end
end
