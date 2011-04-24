hello = lambda {"hello"}
puts hello.call

log = lambda {|str| puts "[LOG] #{str}"}
log.call("test message")

def my_lambda(&aBlock)
  aBlock
end

b = my_lambda { puts "Hello World My Way!" }
b.call

def call_twice
  puts "first!"
  yield
  puts "second!"
  yield
end
call_twice { puts "Hi, I'm a talking code block." }


def repeat(n)
 if block_given?
   n.times { yield }
  else
    raise ArgumentError.new("I can't repeat a block you don't give me!")
  end
end

repeat(4) { puts "Hello." }

#repeat(4)

def call_twice2
  puts "Calling your block."
  ret1 = yield("very first")
  puts "The value of your block: #{ret1}"

  puts "Calling your block again."
  ret2 = yield("second")
  puts "The value of your block: #{ret2}"
end

call_twice2 do |which_time|
  puts "I'm a code block, called for the #{which_time} time."
  which_time == "very first" ? 1 : 2
end

def repeat(n, &block)
  n.times { block.call } if block
end
repeat(2) { puts "Hello." }

