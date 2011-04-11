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
class IssueDetail < ActiveRecord::Base
end
p issue_detail = IssueDetail.find(:first)
issue_detail.detail= 'issue_detail20'
issue_detail.save
p IssueDetail.find_by_detail('issue_detail20')

puts "ok"

