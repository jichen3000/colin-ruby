def me
    p caller_locations()
    puts caller_locations(1,1)[0].label
    "me"
end

puts me

def me_proc
    proc do
        p caller_locations()
        puts caller_locations(1,1)[0].label
        "me"
    end
end

me_p = me_proc
p me_p.call