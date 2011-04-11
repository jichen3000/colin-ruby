require 'active_record'
ActiveRecord::Base.establish_connection(
  :adapter  => "oracle_enhanced",
  :encoding => "utf-16",
  :database => "megatrust",
  :username => "colin_test",
  :password => "colin_test"
)
ActiveRecord::Base.table_name_prefix = "mc$ma_"
# 表名关掉复数默认形式
ActiveRecord::Base.pluralize_table_names = false
class SDbstatus < ActiveRecord::Base
  
end
STORE_CON_COLUMNS=["id", "target_id", "target_type", "warn_config_id", "observation_time", "key_value"]
@store_columns = {}
def instance_name_to_class_name(instance_name)
  instance_name.split("_").map!{|x| x.capitalize!}.join("")
end
def get_value_columns(table_name)
  p @store_columns
  value_columns = @store_columns[table_name]
  if value_columns
    return value_columns
  end
  puts "re get"
  instance_name = table_name.sub(ActiveRecord::Base.table_name_prefix,"")
#  require table_name
  class_name = instance_name_to_class_name(instance_name)
  value_columns = Kernel.const_get(class_name).column_names - STORE_CON_COLUMNS
  @store_columns[table_name] = value_columns
  value_columns
end
#p ActiveRecord::Base.table_name_prefix
#p SDbstatus.column_names
#p SDbstatus.all
p get_value_columns('mc$ma_s_dbstatus')
p get_value_columns('mc$ma_s_dbstatus')
p get_value_columns('mc$ma_s_dbstatus')

