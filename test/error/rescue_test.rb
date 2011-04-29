def my_put
  puts "my"
end
def my_put2
  puts "my2"
end
i = 2
my_puts rescue my_put2
p "ok"