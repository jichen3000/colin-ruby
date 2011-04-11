ENV["MEGATRUST_DAEMON_HOME"] = File.join(File.dirname(__FILE__),"../..")
ENV["RAILS_ENV"] = "test"
#ENV['MEGATRUST_ENV']='development'
require File.join(ENV["MEGATRUST_DAEMON_HOME"],"config/enviroment")
require "active_record"

def gen_line(key,hash)
  value =hash[key]
  '  '+key+': '+value.to_s
end
def gen_yml(class_name)
  require 'issue_keyword_desc'
  all = IssueKeywordDesc.all
  i = 0
  filename = File.join(File.dirname(__FILE__),'issue_keyword_desc.yml')
  f = File.open(filename,'w')
  all.each do |item|
    f.puts 'issue_keyword_desc' + i.to_s + ":"
    IssueKeywordDesc.columns.each do |col|
      if(!col.name.include?('_at'))
        f.puts gen_line(col.name,item.attributes)
      end
    end
    f.puts ''
    i += 1
  end
  f.close
end
p "ok"
