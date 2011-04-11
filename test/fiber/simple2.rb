fib = Fiber.new do
  f1 = f2 = 1
  p "start"
  loop do
    Fiber.yield f1
    f1, f2 = f2, f1 + f2
  end
  p "end"
end

10.times { puts fib.resume }
p "ok"