# create table colin_one(id number(9), name varchar(30), value number);
# create sequence colin_one_seq; 
# create table colin_two(id number(9), name varchar(30), value number);
# create sequence colin_two_seq; 

require 'active_record'
ActiveRecord::Base.establish_connection(
  :adapter  => "oracle_enhanced",
  :database => "98stream",
  :username => "company",
  :password => "company",
  :host     => "98stream"
)
ActiveRecord::Base.pluralize_table_names = false
class ColinOne < ActiveRecord::Base
end

class ColinTwo < ActiveRecord::Base
  def copy_value(one)
    self.attributes.each do |attr_name,attr_value|
      self[attr_name] = one[attr_name]
    end
  end
end

require "test/unit"

class ValueTest < Test::Unit::TestCase
  def setup
    ColinOne.find_or_create_by_name_and_value("colin",3)
  end
  def test_one
    assert_equal(3.0, ColinOne.find_by_name("colin").value)
  end
  def test_copy_value
    one = ColinOne.find_by_name("colin")
    two = ColinTwo.new
    two.copy_value(one)
    two.save
    other_two = ColinTwo.find_by_name(one.name)
    assert_equal(one.value, other_two.value)
  end
end
