class Person < Sequel::Model
  many_to_one :role
end
class Role < Sequel::Model
  one_to_many :people
end
