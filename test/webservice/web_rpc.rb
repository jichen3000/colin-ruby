require "soap/rpc/driver"
class WebRpc
  def perform
    url = "http://172.16.4.107:9000/helloWorld";
    i=0
    
#    start=Time.now
#    puts start
    client = SOAP::RPC::Driver.new(url);
    client.add_rpc_method("getUser","id")
    while(i<20)
      result = client.getUser("1000")
#      p result
#      if result.addresses.class == Array
#        result.addresses.each do |a|
#          #puts "datail=#{a.detail} zipCode=#{a.zipCode}"
#        end
#      else
#        #puts client.getUser("1000").addresses
#      end
#      #puts "age=#{client.getUser("1000").age}"
#      puts "name=#{client.getUser("1000").name}"
      i+=1
    end
#    puts Time.now-start
  end
  
  def perform2
    start=Time.now
    puts start
     i=0
     while (i<1000)
     puts "a"
     i+=1
   end
    puts Time.now-start
  end
end
start = Time.now
WebRpc.new.perform
puts (Time.now - start)