module SecondLevelModule 
    def self.included(base)
        base.extend ClassMethods
    end
    def second_level_instance_method; 'ok'; end
    module ClassMethods
        def second_level_class_method; 'ok'; end
    end 
end
module FirstLevelModule 
    def self.included(base)
        base.extend ClassMethods
    end
    def first_level_instance_method; 'ok'; end
    module ClassMethods
        def first_level_class_method; 'ok'; end
    end
    include SecondLevelModule
end
class BaseClass
    include FirstLevelModule
end

require 'active_support'
module SecondLevelModule1 
    extend ActiveSupport::Concern
    def second_level_instance_method; 'ok'; end
    module ClassMethods
        def second_level_class_method; 'ok'; end
    end 
end
module FirstLevelModule1 
    extend ActiveSupport::Concern
    def first_level_instance_method; 'ok'; end
    module ClassMethods
        def first_level_class_method; 'ok'; end
    end
    include SecondLevelModule1
end
class MyClass
    include FirstLevelModule1
end
if __FILE__ == $0
    require 'minitest/autorun'
    require 'minitest/spec'
    require 'testhelper'

    describe "include-extend trick's issue" do
        it "function" do
            BaseClass.new.first_level_instance_method.must_equal("ok")
            BaseClass.new.second_level_instance_method.must_equal("ok")

            BaseClass.first_level_class_method.must_equal("ok")
            -> {BaseClass.second_level_class_method}.must_raise(NoMethodError)
        end
    end
    describe "use concern" do
        it "" do
            MyClass.new.first_level_instance_method.must_equal("ok")
            MyClass.new.second_level_instance_method.must_equal("ok")

            MyClass.first_level_class_method.must_equal("ok")
            MyClass.second_level_class_method.must_equal("ok")
        end
    end
end