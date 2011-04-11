require 'rubygems'
require 'facets/basicobject'

class BetterHexNumber < BasicObject
  def initialize(integer)
    @value = integer    
  end  
  # in this method, not use puts
  # because it is 
  def method_missing(m,*args)
#    puts "method_missing"
    unless @value.respond_to?(m)
#      puts "super"
      super     
    end
    hex_args = args.collect do |arg|
      arg.kind_of?(BetterHexNumber) ? arg.to_int : arg      
    end
    result = @value.send(m, *hex_args)
    return result if m == :coerce
    case result
    when Integer
      BetterHexNumber.new(result)
    when Array
      result.collect do |element|
        element.kind_of?(Integer) ? BetterHexNumber.new(element) : element        
      end
    else
      result
    end
  end
  def respond_to?(method_name)
#    puts method_name
    super or @value.respond_to? method_name
  end
  def to_s(*args)
    hex = @value.abs.to_s(16)
    sign = self < 0 ? "-" : ""
    "#{sign}0x#{hex}"    
  end
  def inspect
    to_s    
  end
end
class A
  def method_missing(m,*args)
    p m
  end  
end
h = BetterHexNumber.new(100)
p h
p h.succ
#h.mm
#a = A.new
#a.i
