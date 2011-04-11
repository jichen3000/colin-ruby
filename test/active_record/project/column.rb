require "active_record"
#ActiveRecord::Base.establish_connection(
#  :adapter  => "oracle_enhanced",
#  :database => "xe",
#  :username => "colin_test",
#  :password => "colin_test"
#)
#ActiveRecord::Base.pluralize_table_names = false
#ActiveRecord::Base.table_name_prefix = 'mc$ma_'
#log_path = File.join(File.dirname(__FILE__),'sql.log')
#ActiveRecord::Base.logger = Logger.new(log_path, 3, 2048000)
ENV["RAILS_ENV"] = "test"
require File.expand_path("D:/work/workspace/megatrust/megatrust-web/config/environment")
require 'test_help'
class ActorActivity < ActiveRecord::Base
  belongs_to :activity_desc
  belongs_to :old_actor, :class_name =>"User"
  belongs_to :new_actor, :class_name =>"User"
end
class ActorActivityTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def get_simple_tablename
    ActorActivity.table_name.sub(ActiveRecord::Base.table_name_prefix,'')
  end
  def setup
    @column_value = 'actor_activity_s'
    @column_name = 'name'
    ActiveRecord::Migration.add_column(get_simple_tablename, 
        @column_name, :string, {:limit=>30})
    ActorActivity.reload
    ActorActivity.create(
      :name =>"actor_activity1")
  end
  def teardown
    o = ActorActivity.find_by_name("actor_activity1")
    if o
      o.delete
    end
    ActiveRecord::Migration.remove_column(get_simple_tablename,
      @column_name)
  end
#  test "select" do
#    assert_not_nil(actor_activity(:actor_activity1))
#  end
  test "save" do
    ActorActivity.create(
      :name =>@column_value)
    assert_not_nil(ActorActivity.find_by_name(@column_value))    
  end
#  test "update" do 
#    actor_activity =actor_activity(:actor_activity1)
#    actor_activity.name=@column_value
#    actor_activity.save
#    assert_not_nil(ActorActivity.find_by_name(@column_value))
#  end
  test "delete" do
    ActorActivity.find_by_name("actor_activity1").delete
    assert_nil(ActorActivity.find_by_name("actor_activity1"))
  end
#  test "belongs_to_activity_desc" do
#    assert_equal(activity_desc(:activity_desc0),
#      actor_activity(:actor_activity0).activity_desc)
#  end
#  test "belongs_to_old_actor" do
#    assert_eqaul(user(:user0),actor_activity(:actor_activity0).old_actor)
#  end
#  test "belongs_to_new_actor" do
#    assert_equal(user(:user1),actor_activity(:actor_activity0).new_actor)
#  end
end
##p ActorActivity.table_name
#simple_table_name = ActorActivity.table_name.sub(ActiveRecord::Base.table_name_prefix,'')
##p issue_detail = McProcess.find(:first)
#ActiveRecord::Migration.add_column(
#  simple_table_name,'name',:string, {:limit => 30,   :precision => 9})
#ActorActivity.create(
#  :name =>"actor_activity1")    
#ActiveRecord::Migration.remove_column(simple_table_name,'name')
##ActiveRecord::Migration.remove_column(ActorActivity.table_name,'add_column')
puts "ok"


