class Module
  def add_logging(*method_names)
    method_names.each do |method_name|
      original_method = method(method_name).unbind
      define_singleton_method(method_name) do |*args, &blk|
        puts "#{self}.#{method_name} called"
        original_method.bind(self).call(*args, &blk)
      end
    end
  end
end

# class method example
module MyModule
  def self.module_method1
    puts "hello"
  end

  add_logging :module_method1
end

MyModule.module_method1