require 'sqlite3'
require 'sequel'
# I can't find singlize and prefix method
db_file_name= File.join(File.dirname(__FILE__),'simple.db')
db = Sequel.sqlite(db_file_name)

class Person < Sequel::Model
  
end
class Role < Sequel::Model
end
require 'pp'
p Person
pp Person.all
p Person.first
p Person.where('income > ?', 6000).first
p Person.where('income > ?', 6000).all
#ljj = Person.create(:name=>"LJJ")
p ljj


p "ok"