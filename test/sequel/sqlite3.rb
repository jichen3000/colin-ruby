require 'sqlite3'
require 'sequel'
db=Sequel.sqlite(File.join(File.dirname(__FILE__),'simple.db'))
Sequel::Model.plugin :json_serializer
require File.join(File.dirname(__FILE__),'models.rb')


require 'pp'
pp Person.first
jc = Person.first
jc.updated_at=Time.now
jc.save
pp jc.to_json
p jc.values.to_json
p jc.class
# ues from_json will report error
#jc2=Person.new
#jc2.from_json(jc.values.delete(:id).to_json)
jc1 = JSON.parse(jc.to_json)
jc1.updated_at = Time.now
#p jc1==jc
#jc1.save
p jc1
p jc1.class
p "all"
p Person.all.to_json
p Person.all.class
person_json = Person.all.to_json
arr = JSON.parse(person_json)
p arr
p arr.class
#p "id 2"
#p Person[2]