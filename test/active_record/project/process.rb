require "active_record"
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
class IssueProcess < ActiveRecord::Base
end
#p issue_detail = McProcess.find(:first)
@column_value = 11
a = IssueProcess.create(
  :process_level =>@column_value)
p a
puts "ok"

