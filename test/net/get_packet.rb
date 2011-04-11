ip = "your ip"  
cmd = "/usr/sbin/tcpdump -lnA -s 0" #  dst host #{ip} or src host #{ip}  
  
f = IO.popen(cmd) do |f|  
  while true  
    packet = f.read(1024*100)  
    cap = /(\d+\.\d+\.\d+\.\d+).+ > (\d+\.\d+\.\d+\.\d+)/.match(packet)  
    if cap  
      client,host  = cap[1],cap[2]  
      #put 请求方法 ,这个可以根据你抓包的类型，进行自定义过滤  
      reg = /(\?xml|HTTP|XMLHttpRequest|XMLRequest|XMLSchema|XMLSchema-insta0x|XML|GET|POST|WWW-Authenticate|Authorization).+/i  
      method =  reg.match(packet)  
      if method  
        puts "source:#{client} > dest:#{host}"  
        puts "method is #{method[1]}"  
        puts "data >>>"  
        puts method  
      end#end if method   
    end  
  
  end  
end  