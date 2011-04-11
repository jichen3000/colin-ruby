#evens = Fiber.new do
#  value = 0
#  loop do
#    Fiber.yield value
#    value += 2
#  end
#end
#
#consumer = Fiber.new do
#  p "start"#  10.times do
#    next_value = evens.resume
#    puts next_value
#  end
#  p "end"
#end
#
#consumer.resume

p "other"
def evens
  Fiber.new do
    value = 0
    loop do
      Fiber.yield value
      value += 2
    end
  end
end

def consumer(source)
  Fiber.new do
    10.times do
      next_value = source.resume
      puts next_value
    end
  end
end

consumer(evens).resume
p "end"
