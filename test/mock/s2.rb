require 'test/unit'
require 'mocha'
class Duck
  def flap_wings
    "flap_wings"
  end
end
class TestS2 < Test::Unit::TestCase
  def test_s1
    duck = mock("duck")
    duck.expects(:quack)
    duck.quack
  end
  def test_s2
    duck = mock("duck")
    duck.expects(:quack).times(3)
    duck.quack
    duck.quack
    duck.quack
    # failure
    duck.quack
  end
  def test_s3
    duck = mock("duck")
    duck.expects(:waddle).with(2)
    # failure
    duck.waddle(1)
  end
  def test_s4
    duck = mock("duck")
    duck.expects(:swim).with(anything,2)
    duck.swim(1,2)
  end
  def test_s5
    duck = mock("duck")
    duck.stubs(:flap_wings).returns(true,true,false).then.raises(BrokenWingError)
    duck.flap_wings
    duck.flap_wings
    duck.flap_wings
    # error
    duck.flap_wings
  end
  def test_s6
    duck=stub(:animal? => true, :bird? => true)
    duck.animal?   
    duck.bird?   
    duck.bird?
    duck.bird?
    duck.bird?
    duck.other?
  end
  def test_s7
    duck=stub_everything(:bird? => true)
    duck.animal?   
#    assert(duck.bird?,false)   
    p "ok"
    p duck.bird?
    p duck.other?
  end
  def test_s8
    donald = Duck.new
    donald.stubs(:flap_wings).returns(true)
    p donald.flap_wings
  end
  def test_s9
    Duck.stubs(:bird? => true)
    Duck.bird?
    Duck.bird?
  end
  def test_s10
    Duck.any_instance.stubs
  end
  def test_product
    product = stub('ipod_product', :manufacturer => 'ipod', :price => 100)
    assert_equal 'ipod', product.manufacturer
    assert_equal 100, product.price
    # an error will not be raised even if Product#manufacturer and Product#price have not been called
  end

end