require "active_record"
ENV["RAILS_ENV"] = "test"
require File.expand_path("D:/work/workspace/megatrust/megatrust-web/config/environment")
require 'test_help'


class First < ActiveRecord::Base
  has_many :seconds, :dependent=>:destroy
  belongs_to :third
end
class Second < ActiveRecord::Base
  has_many :thirds, :dependent=>:destroy
  belongs_to :first
end
class Third < ActiveRecord::Base
  belongs_to :second
  has_many :first, :dependent=>:destroy
end
ActiveRecord::Migration.create_table "first", :force => true do |t|
  t.string   "name",             :limit => 60
  t.integer  "third_id",         :limit => 9,   :precision => 9, :scale => 0
end
ActiveRecord::Migration.create_table "second", :force => true do |t|
  t.string   "name",             :limit => 60
  t.integer  "first_id",         :limit => 9,   :precision => 9, :scale => 0
end
ActiveRecord::Migration.create_table "third", :force => true do |t|
  t.string   "name",              :limit => 60
  t.integer  "second_id",         :limit => 9,   :precision => 9, :scale => 0
end
dir = File.join(File.dirname(__FILE__),'fixtures1')
Fixtures.create_fixtures(dir,'first')
Fixtures.create_fixtures(dir,'second')
Fixtures.create_fixtures(dir,'third')
class FirstTest < ActiveSupport::TestCase
  test "destroy_first" do
    first0 = First.find_by_name('first0')
    second0 = first0.seconds[0]
    second1 = first0.seconds[1]
    assert_equal(2,first0.seconds[0].thirds.size)
    assert_equal(1,first0.seconds[1].thirds.size)
    first0.destroy
    assert_equal([],Third.find(:all,:conditions=>['second_id = ?',second0.id]))
    assert_equal([],Third.find(:all,:conditions=>['second_id = ?',second1.id]))
  end
end