string = 'HELLo'
string1 = 'hELlO'
reg = /hELlO/
test1=Regexp.compile("Bar");  
test=Regexp.compile(/Bar/i);  #忽略大小写  
puts test1.match("bar") #nil  
puts test.match("bar") #bar

p Regexp.compile('heL', true).match(string) 
p Regexp.compile('heL').match(string) 
