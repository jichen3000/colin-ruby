require 'json'

class PointSelf
    attr_reader :name, :the_self
    def initialize(name)
        @the_self = self
        @name = name
    end
    def to_json
        {:name => @name}.to_json
    end
    # def insepct
    #     {:name => @name}
    # end
end


if __FILE__ == $0
    require 'minitest/autorun'
    require 'minitest/spec'
    require 'testhelper'

    describe PointSelf do
        it "can json" do
            colin = PointSelf.new("Colin")
            colin.inspect().pt()
            colin.to_json().must_equal("{\"name\":\"Colin\"}")
        end
    end
end