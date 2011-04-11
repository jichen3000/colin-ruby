class ColinTest
  
  def self.method_missing(method_name,*args)
    p "#{method_name}"
    args.each_with_index do |item,index|
      p "arg #{index} : #{item}"
    end
    self.class_eval %{
      def self.#{method_name}(*args)
        self.mm *args
      end
    },__FILE__,__LINE__
    send(method_name,*args)
  end
  def self.mm(*args)
    puts "mm" 
    args.each_with_index do |item,index|
      p "arg #{index} : #{item}"
    end
#    p args   
  end
end

ColinTest.ll(1,'mmccc')
  
p 'ok'