# $:为ruby在使用require和load方法时，搜索的路径，可以把路径加入到其中。
p $:
$: << "./array_test"
p $:
#p (require 'array_at_test')

puts "env : #{ENV['ORACLE_HOME']}"
ENV['ORACLE_HOME'] = '\oracle\10g'
puts "env : #{ENV['ORACLE_HOME']}"
