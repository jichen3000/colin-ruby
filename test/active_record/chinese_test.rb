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
class DrTrustStaus < Managerdb
  self.table_name='mc$dr_trust_status'
end
#d = DrTrustStaus.first(:conditions=>"job_id=87326")
#p d 
#uiconv = Iconv.new("utf-8","gbk")
#start = Time.now
#puts uiconv.iconv(d.info)
#p (Time.now - start)

tss = DrTrustStaus.find(:all, :order=>:job_id, :limit=>3)
p tss.size
tss.each do |item|
  p "job_id:#{item.job_id}"
end
p "ok"

