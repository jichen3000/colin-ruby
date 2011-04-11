require 'test/unit'

class Colin
  def initialize(type)
    @type = type
  end
  def simple
    'simple'
  end
  def get_type
    @type
  end
end
class TestColin < Test::Unit::TestCase
  def setup
    @type = "colin"
    @colin = Colin.new(@type)
  end
  def test_get_type
    assert(@colin.get_type, @type)
  end
end
