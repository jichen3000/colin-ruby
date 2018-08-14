class MyClass 
    def my_method
        "original my_method()"
    end
    def another_method 
        my_method
    end 
end
module MyClassRefinement 
    refine MyClass do
        def my_method
        "refined my_method()"
        end 
    end
end
using MyClassRefinement
puts MyClass.new.my_method
puts MyClass.new.another_method