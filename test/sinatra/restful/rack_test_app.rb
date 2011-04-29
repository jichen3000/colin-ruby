require 'rack/test'
require 'test/unit'
require File.join(File.dirname(__FILE__),'app.rb')

ENV['RACK_ENV']='test'

class AppTest < Test::Unit::TestCase
  include Rack::Test::Methods
  
  def app
    Sinatra::Application
  end
  
  def test_select_many
    get '/people'
    result_arr = JSON.parse(last_response.body)
    assert_equal(3,result_arr.size)
    assert_equal('jc',result_arr.first['name'])
  end
  
  def test_select_by_id
    id = 1
    get "/people/#{id}"
    result_person_hash = JSON.parse(last_response.body)
    assert_equal('jc',result_person_hash['name'])
  end
  
  def test_update_by_id
    id = 1
    person1 = Person[id]
    updated_at = Time.now
    assert_not_equal(updated_at.to_s,person1.updated_at.to_s)
    person1.updated_at=updated_at    
    put "/people/#{id}", :values=>person1.values.to_json
    assert_equal(updated_at.to_s,Person[id].updated_at.to_s)    
    assert_equal(1,last_response.body.to_i)    
  end
  def test_update_many
    id2 = 2
    id3 = 3
    update_person2 = Person[id2]
    update_person3 = Person[id3]
    updated_at2 = Time.now-1
    updated_at3 = Time.now
    assert_not_equal(updated_at2.to_s,update_person2.updated_at.to_s)
    assert_not_equal(updated_at3.to_s,update_person3.updated_at.to_s)
    update_person2.updated_at=updated_at2    
    update_person3.updated_at=updated_at3
    put "/people", :values=>[update_person2.values,update_person3.values].to_json
    assert_equal(updated_at2.to_s,Person[id2].updated_at.to_s)    
    assert_equal(updated_at3.to_s,Person[id3].updated_at.to_s)    
    assert_equal(2,last_response.body.to_i)    
  end
  def test_insert_one
    new_person1_values = {:name=>"m1",:income=>12000,:role_id=>1}
    assert_nil(Person[:name=>new_person1_values[:name]])
    post '/people', :values=>new_person1_values.to_json
    new_person = Person[:name=>new_person1_values[:name]]
    assert_not_nil(Person[:name=>new_person1_values[:name]])
    assert_equal(1,last_response.body.to_i)    
    new_person.delete
  end
  def test_insert_manys
    new_person1_values = {:name=>"m1",:income=>12000,:role_id=>1}
    new_person2_values = {:name=>"m2",:income=>22000,:role_id=>1}
    assert_nil(Person[:name=>new_person1_values[:name]])
    assert_nil(Person[:name=>new_person2_values[:name]])
    post '/people', :values=>[new_person1_values,new_person2_values].to_json
    new_person1 = Person[:name=>new_person1_values[:name]]
    new_person2 = Person[:name=>new_person2_values[:name]]
    assert_not_nil(Person[:name=>new_person1_values[:name]])
    assert_not_nil(Person[:name=>new_person2_values[:name]])
    assert_equal(2,last_response.body.to_i)    
    new_person1.delete
    new_person2.delete
  end
  def test_delete_by_id
    id=2
    delete_person = Person[id]
    assert_not_nil(delete_person)
    delete "/people/#{id}"
    assert_equal(1,last_response.body.to_i)    
    assert_nil(Person[id])
    Person.insert(delete_person)
  end
  def test_delete_many
    id2=2
    id3=3
    delete_person2 = Person[id2]
    delete_person3 = Person[id3]
    assert_not_nil(delete_person2)
    assert_not_nil(delete_person3)
    delete "/people", :values => [{:id=>id2},{:id=>id3}].to_json
    assert_equal(2,last_response.body.to_i)    
    assert_nil(Person[id2])
    assert_nil(Person[id3])
    Person.insert(delete_person2)
    Person.insert(delete_person3)
  end
end