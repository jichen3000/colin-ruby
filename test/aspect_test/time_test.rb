require 'aspectr'

class Statistics < AspectR::Aspect
  def describe(method_sym, object, *args)
    "#{object.to_s}.#{method_sym}(#{args.join(",")})"
  end
  def before(method_sym, object, return_value, *args)
    puts "#{describe(method_sym, object, *args)}"
    @begin_time = Time.now
  end
  def after(method_sym, object, return_value, *args)
    @end_time = Time.now
    puts "#{describe(method_sym, object, *args)}"
    puts @begin_time
    puts @end_time
    # 这样做会报错，可能会影响
    f = @end_time.usec - @being_time.usec 
#    puts f.to_s
#    puts "dfd #{(@end_time - @being_time).to_s}"
  end
end

class Test
  def my_sleep(secs)
    sleep(secs)
  end
end

s = Statistics.new
t = Test.new
puts t.to_s
s.wrap(Test, :before, :after, :my_sleep)
t.my_sleep(1)

