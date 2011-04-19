require 'sequel'
require 'pg'
#db=Sequel.connect('postgres://colin@localhost/colindb')
db=Sequel.connect('postgres://colin@72.46.131.199/colindb')
db1=Sequel.postgres('colindb', :user=>'colin', :password=>nil,
	:host=>'72.46.131.199', :port=>5432,
	:max_connections=>10)
puts db1[:pg_am].count
puts db[:pg_am].count

puts "ok"
