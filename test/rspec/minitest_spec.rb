require 'minitest/spec'
require 'minitest/autorun'

describe Array do
  it "can be created with no arguments" do
    Array.new.must_be_instance_of Array
  end

  it "can be created with a specific size" do
    Array.new(10).size.must_equal 10
  end
end

class Colin
  def initialize()
    @cc = "ccc"  
  end
  private 
  def self.y(str)
      str
  end
  def mm(str)
      str
  end
end

describe Colin do
  before do
    @str = "123"
  end
  it "cannot have a class method as private one." do
    # A class method cannot be private.
    Colin.y(@str).must_equal @str
  end
  it "cannot test an instance private method directly!" do
    # Colin.new.mm(@str)
    lambda { Colin.new.mm(@str) }.must_raise NoMethodError
    # Proc.new(Colin.new.mm(@str)).must_raise NoMethodError
  end
  it "can test an instance private method by the 'send' method of Object." do
    Colin.new.send(:mm, @str).must_equal @str
    Colin.new.send(:mm, @str).must_equal '456'
  end
  it "can be test an instance private variable" do
    Colin.new.instance_variable_get('@cc').must_equal "ccc"
    Colin.new.instance_variable_get('@cc').must_equal "ccc1"
  end
end