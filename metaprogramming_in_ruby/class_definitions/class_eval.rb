def add_method_to(a_class) 
    a_class.class_eval do
        def m; 'Hello!'; end 
    end
end

if __FILE__ == $0
    require 'minitest/autorun'
    require 'minitest/spec'
    require 'testhelper'

    describe "some" do
        it "function" do
            add_method_to(String)
            "".m.must_equal("Hello!")
        end
    end
end
