module ObjectExtension
  def nil_or
    return self unless self.nil?
    Class.new do
      def method_missing(sym, *args); return "WARN:::nil"; end
    end.new
  end  
  
end

class Object
#  include ObjectExtension
  def method_missing(sym, *args)
    warn sym
    
    return "WARN:::nil"
  end
end

a.nil_or.puts
puts "ok"