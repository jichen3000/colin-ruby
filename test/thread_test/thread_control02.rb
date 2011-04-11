require 'active_record'
#require 'oci8'
#ENV["MEGATRUST_DAEMON_HOME"] = File.join(File.dirname(__FILE__),"../")
#require File.join(ENV["MEGATRUST_DAEMON_HOME"],"config/enviroment")
  
ActiveRecord::Base.establish_connection(
  :adapter  => "oracle_enhanced",
  :database => "megatrust",
  :username => "colin_test",
  :password => "colin_test"
)
class One < ActiveRecord::Base
  self.table_name = "mc$ma_one"
end
filename = File.join(File.dirname(__FILE__),'thread_log'+'.log')
$logger = Logger.new(filename)

def create_thread(one,thread_arr)
  thread_arr << Thread.new do 
  while one
    puts "One.a =#{one} #{one.id} "
    sleep(0.5)
    begin
      one.reload
    rescue =>e
      $logger.error(e)
    end
  end
  end
end

def get_object_value(one)
  while true
    puts "One.a =#{one} #{one.id} "
    sleep(0.5)
#    one = One.find(one.id)
#    begin
#      one.reload(:lock => true)
#      puts "now one.a = #{one}"
#    rescue
#      $one_hasn.delete(one.id)
#      break
#    end
  end
end

thread_arr = []
$one_hash = {}
   
while true
  ones = One.find(:all)
  ones.each do |item|
    if $one_hash[item.id] == nil
      $one_hash[item.id] = item
      create_thread(item,thread_arr)
    end
  end
  puts '-----------------------'
  sleep(3)
end
