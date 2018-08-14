class A
    def get(arg)
        arg
    end
end

if __FILE__ == $0
    require 'minitest/autorun'
    require 'minitest/spec'
    require 'testhelper'

    describe "some" do
        it "function" do
            a = A.new
            a.get(1).pt
            m = a.class.instance_method(:get)
            a.define_singleton_method(:get) do |*args, &block|
                puts  "do"
                # a.get(*args, &block)
                m.bind(a).(*args, &block)
            end
            # def a.get(arg)
            #     puts "do something"
            #     puts a
            #     # a.get(arg)
            # end
            a.get(1).pt
            b = A.new
            b.get(1).pt
            # alias_method(a.get,)
        end
    end
end