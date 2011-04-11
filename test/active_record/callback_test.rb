require 'base_conn'

#new_li = LogInfo.new
#new_li.name = "c_t"
#new_li.save

#new_li = LogInfo.find_by_name("c_t")
#new_li.destroy


new_oli = OraLogInfo.new
new_oli.name = "c_t"
new_oli.save
#
#new_oli = OraLogInfo.find_by_name("c_t")
#new_oli.destroy

oli = OraLogInfo.find_by_name("c_t")
p oli.full_name
p oli.create_time
oli.save
p oli

p "ok"