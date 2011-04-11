require 'test_helper'

class HostTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def setup
    @column_value = 'host_s'
  end
  test "select" do
    assert_not_nil(host(:host1))
  end
  test "save" do
    Host.create(
      :name =>@column_value)
    assert_not_nil(Host.find_by_name(@column_value))    
  end
  test "update" do 
    host =host(:host1)
    host.name=@column_value
    host.save
    assert_not_nil(Host.find_by_name(@column_value))
  end
  test "delete" do
    host(:host1).delete
    assert_nil(Host.find_by_name("host1"))
  end
end