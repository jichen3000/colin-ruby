class Colin
    def mm
        puts "mm"
        @mm = "m1"
        @list = []
        require "pry"; binding.pry
    end
end

$ll = "ll"
Colin.new.mm
puts "ok"