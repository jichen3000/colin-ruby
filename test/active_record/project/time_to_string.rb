require "active_record"
ActiveRecord::Base.establish_connection(
  :adapter  => "oracle_enhanced",
  :database => "xe",
  :username => "colin_test",
  :password => "colin_test"
)
ActiveRecord::Base.pluralize_table_names = false
log_path = File.join(File.dirname(__FILE__),'sql.log')
ActiveRecord::Base.logger = Logger.new(log_path)
#ActiveRecord.time_zone = nil
class Times < ActiveRecord::Base
end
require 'date'
require 'active_support'
Times.columns.each do |item|
  p item
end
Times.all.each do |item|
 p  item.a.strftime("%Y-%m-%d %H:%M:%S")
end
#@column_value = Date.today
#Observation.delete_all
#o = Observation.create(
#  :observation_time =>@column_value)
#p o
#p o.observation_time.to_s
#p o.to_json

#p o.to_json
#p Observation.find_by_observation_time(@column_value)
#p (Observation.find_by_observation_time(@column_value)==o)
puts "ok"
