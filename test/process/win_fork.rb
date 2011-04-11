
require 'win32/process'

class Subftest
  def initialize
    puts "sub prcess initialize"
  end
  
  def service
    puts "sub process running."
    sleep(10)
  end
end

class Ftest
  def initialize
    puts "initialize"
  end
  
  def self.service
    puts "father process"
    Process.fork do 
      p "fork start"
#      a=Subftest.new
#      a.service
      p "fork end"
    end
    puts "father process is end."
#    Process.wait
  end
end

Ftest.service
p "ok"