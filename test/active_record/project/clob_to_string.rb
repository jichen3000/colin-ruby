require "active_record"
require "active_record/fixtures"
def gen_ymls(instance_names)
  instance_names.each do |instance_name|
    gen_yml(instance_name)
  end
end    
def instance_name_to_class_name(instance_name)
  instance_name.split("_").map!{|x| x.capitalize!}.join("")
end
def gen_line(column,hash)
  require 'active_support'
  value =hash[column.name]
  if column.type == :string && value
    value = value.to_json.gsub!(':','\:')
    return '  '+column.name+': '+value
  elsif column.type == :text && value
    return '  '+column.name+': '+value.to_json.gsub("\000",' ')
  else
    return '  '+column.name+': '+value.to_json
  end 
end
def gen_yml(instance_name) 
  class_name = instance_name_to_class_name(instance_name)
  all = eval(class_name).all(:order=>'id')
  i = 1
  filename = File.join(File.dirname(__FILE__),'fixtures',instance_name+'.yml')
  f = File.open(filename,'w')
  all.each do |item|
    f.puts instance_name + item.id.to_s + ":"
    eval(class_name).columns.each do |col|
    if(!col.name.include?('_at'))
      f.puts gen_line(col,item.attributes)
    end
  end
  f.puts ''
  i += 1
  end
  f.close
end
ActiveRecord::Base.establish_connection(
  :adapter  => "oracle_enhanced",
  :database => "xe",
  :username => "colin_test",
  :password => "colin_test"
)
ActiveRecord::Base.pluralize_table_names = false
ActiveRecord::Base.table_name_prefix = "mc$ma_"
log_path = File.join(File.dirname(__FILE__),'sql.log')
ActiveRecord::Base.logger = Logger.new(log_path)

#ActiveRecord.time_zone = nil
class IssueDetail < ActiveRecord::Base
end
dir = File.join(File.dirname(__FILE__),'fixtures')
Fixtures.create_fixtures(dir,'issue_detail')
#require 'yaml'
#p File.open(File.join(dir,'issue_detail'+'.yml')).readlines
#gen_ymls(["issue_detail"])
puts "ok"
