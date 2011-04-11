require 'test_helper'

class DatabaseTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def setup
    @column_value = 'database_s'
  end
  test "select" do
    assert_not_nil(database(:database1))
  end
  test "save" do
    Database.create(
      :name =>@column_value)
    assert_not_nil(Database.find_by_name(@column_value))    
  end
  test "update" do 
    database =database(:database1)
    database.name=@column_value
    database.save
    assert_not_nil(Database.find_by_name(@column_value))
  end
  test "delete" do
    database(:database1).delete
    assert_nil(Database.find_by_name("database1"))
  end
end