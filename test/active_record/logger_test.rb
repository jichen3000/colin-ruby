require 'base_conn'

#mylog = Logger.new('mylog.txt')
mylog = Logger.new(STDOUT)
ActiveRecord::Base.logger = mylog

JobInfo.benchmark("Testing ben") do
  j_arr = JobInfo.find(:all)
end

mylog.info("create!")


p "ok"
