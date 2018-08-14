class String
    def self.inherited(subclass)
        puts "#{self} was inherited by #{subclass}" 
    end
end
module M1
    def self.included(othermod)
        puts "M1 was included into #{othermod}" 
    end
end
module M2
    def self.prepended(othermod)
        puts "M2 was prepended to #{othermod}" 
    end
end

if __FILE__ == $0
    require 'minitest/autorun'
    require 'minitest/spec'
    require 'testhelper'

    describe "some" do
        it "function" do
            -> {class MyString < String; end}.must_output(
                    "String was inherited by MyString\n")
        end
        it "" do
            Proc.new do
                class C 
                    include M1 
                    prepend M2
                end
            end.must_output("M1 was included into C\n"+
                "M2 was prepended to C\n")
        end
    end
end