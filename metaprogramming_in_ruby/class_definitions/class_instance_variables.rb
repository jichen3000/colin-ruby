class MyClass
    # class instace variable
    @my_var = 1 # self is MyClass
    def self.read; @my_var; end 
    def write
        # object instance variable
        @my_var = 2 # self is object
    end 
    def read; @my_var; end

    # class variable
    @@cls_var = 2
    def self.read_cls; @@cls_var; end
end

class MyChild < MyClass
end

if __FILE__ == $0
    require 'minitest/autorun'
    require 'minitest/spec'
    require 'testhelper'

    describe "some" do
        it "function" do
            obj = MyClass.new
            # object instance
            obj.read.must_equal(nil)
            obj.write
            obj.read.must_equal(2)
            # class instance
            MyClass.read.must_equal(1)

            MyClass.read_cls.must_equal(2)

            # class instance cannot be heritaged
            MyChild.read.must_equal(nil)
            
            MyChild.read_cls.must_equal(2)
        end
    end
end