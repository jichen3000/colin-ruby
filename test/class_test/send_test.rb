class Test
  def hello(str)
    p "hello: #{str}"
  end
end

t = Test.new
p t.respond_to?("hello")
t.send("hello","colin")