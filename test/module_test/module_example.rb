module GA
    def self.set_functions(functions)
        @@functions = functions
    end
    def self.get_function(index)
        @@functions[index]
    end

end



if __FILE__ == $0
    require 'minitest/spec'
    require 'minitest/autorun'
    require 'testhelper'

    describe GA do
        it "can set class variable" do
            GA.set_functions(%w{a b c})
            GA.get_function(1).pt()
        end
    end
end