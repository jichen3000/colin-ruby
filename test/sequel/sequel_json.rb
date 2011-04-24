require 'sqlite3'
require 'sequel'
db=Sequel.sqlite(File.join(File.dirname(__FILE__),'simple.db'))
require 'logger'
log_filename = File.join(File.dirname(__FILE__),'test.log')
db.logger = Logger.new(log_filename)
Sequel::Model.plugin :json_serializer
require File.join(File.dirname(__FILE__),'models.rb')

def test_save
  p Person.first
  jc = Person.first
  jc.updated_at=Time.now
  jc.save
end
def test_to_json
  jc = Person.first
  p jc.to_json
  p jc.values.to_json
  p jc.class
end
def test_all_to_json
  all = Person.all
  p all.to_json
  p all.class
end
def test_from_json_with_parse
  jc = Person.first
  p jc.to_json
  jc_from_json = JSON.parse(jc.to_json)
  p jc_from_json
  p jc_from_json.class
  p jc==jc_from_json
end
def test_from_json_with_instance
  jc = Person.first
  jc_hash = jc.values.dup
  jc_hash.delete(:id)
  # ues from_json will report error
  jc2=Person.new
  #jc2.from_json(jc.values.delete(:id).to_json)
end
def test_from_json_then_instance_save
  jc = Person.first
  p jc
  jc1 = JSON.parse(jc.to_json)
  jc1.updated_at = Time.now
  # must delete id, otherwise it will report id some error
  jc1.values.delete(:id)
  p jc1.values
  # jc1 can't just save.
  jc.update(jc1.values)
  p Person.first
end
def test_from_json_then_classs_save
  jc = Person.first
  p jc
  jc1 = JSON.parse(jc.to_json)
  jc1.updated_at = Time.now
  Person.where(:id=>jc1.id).update(jc1.values)
  p Person.first
end


test_from_json_then_classs_save
p "ok"