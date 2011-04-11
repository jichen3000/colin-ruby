#gem install aspectr --include-dependencies
require 'aspectr'
class Verbose < AspectR::Aspect
  def describe(method_sym, object, *args)
    "#{object.inspect}.#{method_sym}(#{args.join(",")})"
  end

  def before(method_sym, object, return_value, *args)
    puts "About to call #{describe(method_sym, object, *args)}."
  end

  def after(method_sym, object, return_value, *args)
    puts "#{describe(method_sym, object, *args)} has returned " +
      return_value.inspect + '.'
  end
end

verbose = Verbose.new
stack = []
#verbose.wrap(stack, :before, :after, :push, :pop)
verbose.wrap(stack, :before, :after, :push)
stack.push(10)
stack.pop

puts "ok"