require 'pp'

def get_array(str)
  r = nil
#  pp str.class
  if str.class == String
#    puts 'String 01'
    r = [str]
  elsif str.class == Array
#    puts 'A 3'
    r = str
  end
  r
end
pp get_array('2')
@total_row_count = 1
old_total_row_count = 2
puts "total del percent: #{1 - @total_row_count.to_f/old_total_row_count}/"
pp get_array(['jc','mm'])

p 'a string'.class                                   # => String
p 'a string'.class.name                              # => "String"
p 'a string'.class.superclass                        # => Object
p String.superclass                                  # => Object
p String.class                                       # => Class
p String.class.superclass                            # => Module
p 'a string'.class.new                               # => ""
p Object.superclass
