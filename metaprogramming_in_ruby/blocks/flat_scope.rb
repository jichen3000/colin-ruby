my_var = "success"

MyClass = Class.new do
    "#{my_var} in the class definition"

    define_method :my_method do
        "#{my_var} in the method"
    end
    
end

puts MyClass.new.my_method