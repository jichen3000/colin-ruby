require "activerecord"
require "iconv"

class Managerdb < ActiveRecord::Base
  self.establish_connection(
    :adapter  => "oracle",
    :encoding => "utf-16",
    :database => "drb",
    :username => "mcdbra",
    :password => "mcdbra",
    :host     => "drb"
  )
  class << self
  end
end
class DrPVDatabase < Managerdb
  self.table_name = 'v$database'
#  def resetlogs_change
#    return read_attribute("resetlogs_change#")
#  end
#  def resetlogs_change=(ntmp)
#    write_attribute("resetlogs_change#",ntmp)
#  end
  
end
class Some < Managerdb
  self.table_name='gv$archived_log'
  
end
# type: GET,SET,ALL
def gen_method(ac,type)
  arr = []
#  p ac.column_names
  ac.column_names.each do |item|
    # 35为‘#’
    if item.include?('#')
      case type
      when 'GET' then gen_get(arr,item,item.gsub('#',''))
      when 'SET' then gen_set(arr,item,item.gsub('#',''))
      when 'ALL' then
        begin
          gen_get(arr,item,item.gsub('#',''))
          gen_set(arr,item,item.gsub('#',''))
        end
      end
      
    end
  end
  puts "gen start...."
  arr.each do |item|
    puts item
  end
  puts "gen end!"
  arr
end
def gen_get(arr,from_name,to_name)
  arr << "def #{to_name}"
  arr << "  return read_attribute('#{from_name}')"
  arr << "end"
end
def gen_set(arr,from_name,to_name)
  arr << "def #{to_name}=(ntmp)"
  arr << "  write_attribute('#{from_name}',ntmp)"
  arr << "end"
end
gen_method(Some,'GET')
p "ok"