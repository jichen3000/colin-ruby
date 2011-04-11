require "active_record"
ActiveRecord::Base.establish_connection(
  :adapter  => "oracle_enhanced",
  :database => "xe",
  :username => "colin_test",
  :password => "colin_test"
)
ActiveRecord::Base.pluralize_table_names = false
ActiveRecord::Base.table_name_prefix = 'mc$ma_'
log_path = File.join(File.dirname(__FILE__),'sql.log')
ActiveRecord::Base.logger = Logger.new(log_path, 3, 2048000)
ActiveRecord.time_zone = nil
class Observation < ActiveRecord::Base
end
require 'date'
@column_value = Date.today
Observation.delete_all
o = Observation.create(
  :observation_time =>@column_value)
p o
p o.observation_time.to_s
p o.to_json
require 'active_support'
p o.to_json
p Observation.find_by_observation_time(@column_value)
p (Observation.find_by_observation_time(@column_value)==o)
puts "ok"


