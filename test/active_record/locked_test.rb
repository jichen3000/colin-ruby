require 'activerecord'
ActiveRecord::Base.establish_connection(
  :adapter  => "oracle",
  :database => "drb",
  :username => "dbratest",
  :password => "dbratest"
)
ActiveRecord::Base.lock_optimistically  = true
class JbTest < ActiveRecord::Base
  self.table_name = 'mc$jb_test'
end

jb1 = JbTest.find(10034)
jb2 = JbTest.find(10034)
puts "  pre:"
p jb1
p jb2
jb1.email = "222"
jb1.save

puts "  aft:"
p jb1
p jb2
jb2.email = "aaa"
jb2.save

p "ok"