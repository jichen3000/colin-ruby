require "active_record"
require 'date'
ActiveRecord::Base.establish_connection(
  :adapter  => "oracle_enhanced",
  :database => "xe",
  :username => "megatrust_test",
  :password => "megatrust_test"
)
ActiveRecord::Base.pluralize_table_names = false
ActiveRecord::Base.table_name_prefix = 'mc$ma_'
log_path = File.join(File.dirname(__FILE__),'sql.log')
ActiveRecord::Base.logger = Logger.new(log_path, 3, 2048000)
class Observation < ActiveRecord::Base
end
@column_value = Date.today
#p Observation.find(:all)
o = Observation.create(
  :observation_time =>@column_value)
#p o
p     Observation.find_by_observation_time(Date.parse('2010-04-02'))

#p Observation.find_by_observation_time
puts "ok"
