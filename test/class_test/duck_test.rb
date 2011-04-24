require 'pp'
# duck typing的精神就是行为决定类型，而不是相反 
## #不用  
# if a.kind_of? Array then a << 1  
# if a.instance_of? Array then a << 1  
# #而用  
# if a.respond_to? :<< then a << 1  
a = []
a << 3 if a.respond_to? :<<
pp a

sing = class << self; self; end
pp sing