require 'pg'
require 'sequel'

db=Sequel.connect('postgres://colin@72.46.131.199/colindb')

#db.drop_table :people
db.create_table! :people do
  primary_key :id
  Int :role_id
  String :name
  Int :income  
  DateTime :created_at
  DateTime :updated_at
end
#db.drop_table :roles
db.create_table! :roles do
  primary_key :id
  String :permission
  DateTime :created_at
  DateTime :updated_at
end

class Person < Sequel::Model
  many_to_one :role
end
class Role < Sequel::Model
  one_to_many :people
end

super_role = Role.create(
  :permission=>'super',
  :created_at=>Time.now
)

normal_role = Role.create(
  :permission=>'normal',
  :created_at=>Time.now
)

Person.create(
  :name => 'jc',
  :role => super_role,
  :income => 10000,
  :created_at=>Time.now
)
Person.create(
  :name => 'lm',
  :role => super_role,
  :income => 6000,
  :created_at=>Time.now
)
Person.create(
  :name => 'ljj',
  :role => normal_role,
  :income => 3500,
  :created_at=>Time.now
)

p "ok"
