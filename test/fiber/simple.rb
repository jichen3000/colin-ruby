require 'fiber'

fiber = Fiber.new do |first|
#  sleep 5
  p "start"
  second = Fiber.yield first + 2
  p "end"
#  p self
end
puts fiber.alive?
puts fiber.resume(13)
puts fiber.alive?
p "o1"

puts fiber.resume(14)
p "o2"
#puts fiber.resume(17)
#p "o3"
