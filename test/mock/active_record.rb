require 'test/unit'
require 'mocha'
require "activerecord"

ActiveRecord::Base.establish_connection(
  :adapter  => "oracle",
  :database => "colin",
  :username => "colin",
  :password => "colin",
  :host     => "colin-book"  
)
class Product < ActiveRecord::Base
  include ProductMethod
#  belongs_to :parent, :class_name => "JobInfo", :foreign_key => "job_id"
#  belongs_to :job_info, :foreign_key => "job_id"
  belongs_to :job_info
  def before_save
    p "before LogInfo save!!"
  end
  def after_save
    p "after LogInfo save!!!"
  end  
  before_destroy :pdes
  def pdes
    p "before LogInfo destroy!"
  end
end
module ProductMethod
  def check()
    p "check"
  end
end

class ProductMock
  include ProductMethod
end
class MiscExampleTest < Test::Unit::TestCase
  def setup
#    Product.stubs(:new).returns(Product.new)
#    ActiveRecord::Base.connection.stubs(:columns).with('mytable').returns(true)
  end
  def test_mocking_a_class_method
    product = mock()
    product.stubs(:id => 1)
    Product.expects(:find).with(1).returns(product)
    assert_equal product, Product.find(1)
    assert product.id, 1
    assert product.id, 1
  end

  def test_mocking_an_instance_method_on_a_real_object
#    ActiveRecord::Base.stubs(:initialize).returns(nil)
#    Product.stubs(:super).return(:Object)
    product = mock()
    product.expects(:save).returns(true)
    assert product.save
  end

  def test_stubbing_instance_methods_on_real_objects
    prices = [stub(:pence => 1000), stub(:pence => 2000)]
    product = mock()
    product.stubs(:prices).returns(prices)
    assert_equal [1000, 2000], product.prices.collect {|p| p.pence}
  end

#  def test_stubbing_an_instance_method_on_all_instances_of_a_class
#    Product.any_instance.stubs(:name).returns('stubbed_name')
#    product = mock()
#    assert_equal 'stubbed_name', product.name
#  end

  def test_traditional_mocking
    object = mock()
    object.expects(:expected_method).with(:p1, :p2).returns(:result)
    assert_equal :result, object.expected_method(:p1, :p2)
  end

  def test_shortcuts
    object = stub(:method1 => :result1, :method2 => :result2)
    assert_equal :result1, object.method1
    assert_equal :result2, object.method2
  end
  
end