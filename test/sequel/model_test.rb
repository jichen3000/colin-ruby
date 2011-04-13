require 'sqlite3'
require 'sequel'
# I can't find singlize and prefix method
db_file_name= File.join(File.dirname(__FILE__),'simple.db')
db = Sequel.sqlite(db_file_name)

class Person < Sequel::Model
  many_to_one :role
end
class Role < Sequel::Model
  one_to_many :people
end
require 'pp'
#p Person
Person[:name=>'CJ'].update(:role=>Role[:permission=>'SUPER'])
Person[:name=>'FYT'].update(:role=>Role[:permission=>'SUPER'])
p Person[:name=>'FYT'].role
Person[:name=>'LM'].role=Role[:permission=>'NORMAL']
Person[:name=>'LM'].updated_at = Time.now
Person[:name=>'LM'].save
p Person[:name=>'LM'].role
p "new"
lm = Person[:name=>'LM']
lm.updated_at = Time.now
lm.role=Role[:permission=>'NORMAL']
lm.save
pp Person.all
pp Role.all
pp Role[:permission=>'SUPER'].people
#p Person.first
#p Person.where('income > ?', 6000).first
#p Person.where('income > ?', 6000).all
#ljj = Person.create(:name=>"LJJ")
#p ljj


p "ok"