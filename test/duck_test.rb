require 'pp'
# duck typing�ľ��������Ϊ�������ͣ��������෴ 
## #����  
# if a.kind_of? Array then a << 1  
# if a.instance_of? Array then a << 1  
# #����  
# if a.respond_to? :<< then a << 1  
a = []
a << 3 if a.respond_to? :<<
pp a

sing = class << self; self; end
pp sing