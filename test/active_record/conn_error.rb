# 问题：在持续使用查询时，oracle库关闭时，会报下面的错误。
# 1033、1034、3113
# ORA-01034，在已经关掉的时候会报。
# 其中3113有时会抓不到。
#aa
#alter system switch logfile;
#shutdown immediate
#startup
require "activerecord"

class Productdb < ActiveRecord::Base
  class << self
    def connect_productdb
        Productdb.establish_connection(
        :adapter  => "oracle_enhanced",
        :encoding => "utf-16",
        :database => "dbtest",
        :username => "system",
        :password => "oracle",
        :host     => "dbtest"
        )
    end    
  end
end

class Tab < Productdb
  self.table_name="tab"
end
Productdb.connect_productdb
#DrSystemComponents.find(:all,:conditions=>"ip_address ='#{@local_ip}' and subcompoent_type='#{subcompoent_type}'")
begin
  index = 0
  while true
#    p "index:#{index}"
    Tab.find(:first)
#    sleep(2)
    index += 1
  end
rescue Exception => e
  p e.message
end
p "ok"
# ORA-01089
