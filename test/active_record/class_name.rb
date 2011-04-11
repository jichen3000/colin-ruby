require 'active_record'

ActiveRecord::Base.establish_connection(
  :adapter  => "oracle_enhanced",
  :encoding => "utf-16",
  :database => "megatrust",
  :username => "colin_dev",
  :password => "colin_dev"
)
ActiveRecord::Base.table_name_prefix = "mc$ma_"
# 表名关掉复数默认形式
ActiveRecord::Base.pluralize_table_names = false
class IssueMail < ActiveRecord::Base
end

p IssueMail.class_name
p IssueMail.class.name
im = IssueMail.new
p im.class.name