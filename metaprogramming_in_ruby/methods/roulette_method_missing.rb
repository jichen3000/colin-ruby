class Roulette
    def method_missing(name, *args)
        person = name.to_s.capitalize 
        number = 1
        3.times do
            number = rand(10) + 1
            puts "#{number}..." 
        end
        "#{person} got a #{number}" 
    end
end

if __FILE__ == $0
    require 'minitest/autorun'
    require 'minitest/spec'
    require 'testhelper'

    describe "some" do
        it "function" do
            number_of = Roulette.new
            puts number_of.colin
            puts number_of.li

        end
    end
end