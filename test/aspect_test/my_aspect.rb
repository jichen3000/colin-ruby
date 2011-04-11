module AopAspects  
  def log_method(*args)  
    puts "log here"  
    args.each do |arg|  
      puts arg.to_s  
    end  
  end  
     
  def trans_aspect(*args)  
    puts "trans here"  
  end  
  
  def log_before(method,*args)
    @start_time = Time.now
    puts "Method #{method} start."
  end
  def log_after(method,*args)
    @end_time = Time.now
    puts "Method #{method} end!"
    puts "#{(@end_time-@start_time).to_f.to_s}"
  end
end  
module AopBinder  
  def self.included(c) 
    c.extend(AopGenerate)  
  end  
     
  module AopGenerate  
    def run_before(method,*aspects)  
      alias_method "#{method}_before_old".to_sym, method  
      before_method = ""  
      method_name = "method_name"  
      aspects.inject("") {|before_method,aspect| before_method<<(aspect.to_s + "(#{method_name},*args)\n")}  
      s = <<-EOF  
        def #{method}(*args)  
          #{method_name} = "#{method}"  
          #{before_method}  
          #{method}_before_old(*args)  
        end  
      EOF
#      puts s
      class_eval(s)
    end  
    
    def run_after(method,*aspects)  
      alias_method "#{method}_after_old".to_sym, method  
      before_method = ""
      method_name = "method_name"  
      aspects.inject("") {|before_method,aspect| before_method<<(aspect.to_s + "(#{method_name},*args)\n")}  
      s = <<-EOF  
        def #{method}(*args)
          #{method_name} = "#{method}"  
          #{method}_after_old(*args)  
          #{before_method}  
        end  
      EOF
#      puts s
      class_eval(s)
    end  
    def log_round(method,before,after)
      run_before method, before   
      run_after method, after    
    end
    
  end 
   
end

 class AopTest  
   include AopAspects  
   include AopBinder  
   def initialize  
   end  
     
   def run  
     puts "hello, my run" 
     sleep(1) 
   end  
     
   def run2(name="")  
     puts "hello, #{name}"  
   end  
   log_round :run, :log_before, :log_after
#   run_before :run, :log_before  
#   run_after :run, :log_after  
#   run_before :run2, :log_method  
#   run_after :run2, :log_method, :trans_aspect  
 end  

 a = AopTest.new  
# p AopTest.private_methods
 a.run  
 a.run2("ben")  