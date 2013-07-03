require 'date'

Event = Struct.new(:name, :date)

e = Event.new("jc")
p e
e.date = Date.today
p e

e.freeze
e.name[0] = "2"

p e
# p e.has_attributes?