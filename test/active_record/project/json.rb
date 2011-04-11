require "active_record"
ActiveRecord::Base.establish_connection(
  :adapter  => "oracle_enhanced",
  :database => "xe",
  :username => "megatrust_test",
  :password => "megatrust_test"
)
ActiveRecord::Base.pluralize_table_names = false
ActiveRecord::Base.table_name_prefix = 'mc$ma_'
#log_path = File.join(File.dirname(__FILE__),'sql.log')
#ActiveRecord::Base.logger = Logger.new(log_path, 3, 2048000)
class ObservationConfig < ActiveRecord::Base
end

p ObservationConfig.first

json = ObservationConfig.first.attributes.to_json

hash = ActiveSupport::JSON.decode(json)
p hash

#from = ObservationConfig.new
#from.from_json(json)
#p from