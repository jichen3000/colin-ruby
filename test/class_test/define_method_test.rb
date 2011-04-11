class A
  define_method(:print_jc) {puts "jc"}  
  def create_method(name,&block)
    self.class.send(:define_method,name,&block)
  end
end

a = A.new
a.print_jc
a.create_method(:print_self) {puts self}
a.print_self

class Object
  def deep_copy
    Marshal.load(Marshal.dump(self))
  end
end
