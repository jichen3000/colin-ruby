require 'testhelper'

module Colin
    def self.included(klass)
        klass.extend ClassMethods
    end
    def cc
        "cc"
    end
    module ClassMethods
        def mm
            "mm #{@i_var}"
        end
    end
end

class Person
    @i_var = 3
    include Colin
end

module Colin1
    def self.included(klass)
        this = self
        class_methods = methods(false).reject {|x| x==__method__}
        class_methods.each do |method_name|
            # original_method = method(method_name).unbind
            # parameters = this.method(method_name).parameters.map {|x| x[1]}
            # klass.define_singleton_method(method_name) do |*parameters, &blk|
            #     # this.method(method_name).call(*parameters, &blk)
            #     original_method.bind(self)
            #     # original_method.bind(klass.singleton_class).call(*parameters, &blk)
            # end
            # method_name.pt
            klass.singleton_class.instance_eval do
                # this.pt
                parameters = this.method(method_name).parameters.map {|x| x[1]}
                # require "pry"; binding.pry
                # define_method method_name, this.method(method_name)
                # parameters.pt
                define_method method_name do |*parameters|
                    # require "pry"; binding.pry
                    # this.method(method_name).call(*parameters)
                    klass.singleton_class.class_exec(*parameters,&this.method(method_name).to_proc)
                end
            end
        end
    end
    def self.mm(arg1, arg2)
        "mm #{arg1} #{arg2} #{@i_var}"
    end
    def cc
        "cc"
    end
end
class Person1
    @i_var = 3
    include Colin1
end

if __FILE__ == $0
    require 'minitest/autorun'
    require 'minitest/spec'


    describe "some" do
        it "function" do
            colin = Person.new
            colin.cc.must_equal("cc")
            Person.mm.must_equal("mm 3")
        end
        it "function" do
            colin1 = Person1.new
            # colin.cc.must_equal("cc")
            Person1.mm(1,2).must_equal("mm 1 2 ")
            # Class.mm(1,2).pt
        end
    end
end