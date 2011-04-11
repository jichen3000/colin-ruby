str = 'error in file'
str1 ='error in file /tmp/company.dmp'
loc = str1.index(str)+1
loc = str1.rindex(str)+str.length+1
p loc
puts str1[loc..-1]
p 'ok'
