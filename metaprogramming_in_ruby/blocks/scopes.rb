require 'testhelper'
v1 = 1
puts "local_variables: #{local_variables}"
puts "global_variables: #{global_variables}"
class MyClass
    v2 = 2 
    puts "local_variables: #{local_variables}"
    def my_method
        v3 = 3
        v2 =5 
        puts "local_variables: #{local_variables}"
    end
    puts "local_variables: #{local_variables}"
end
obj = MyClass.new
obj.my_method
puts "local_variables: #{local_variables}"