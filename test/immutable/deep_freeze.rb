require 'date'
require 'ice_nine'

Event = Struct.new(:name, :date)

e = Event.new("jc")
p e
e.date = Date.today
p e

# e.freeze
e.name[0] = "2"
p e


e.deep_freeze
e.name[0] = "3"

# p e.has_attributes?