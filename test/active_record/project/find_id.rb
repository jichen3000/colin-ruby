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
end
p ActorActivity.first(100)
ActorActivity.find(100)
puts "ok"
