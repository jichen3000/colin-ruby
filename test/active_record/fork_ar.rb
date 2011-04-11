require 'activerecord'
def establish_connection
  ActiveRecord::Base.establish_connection(
  #  :adapter  => "oracle",
  #  :database => "mc32",
  #  :username => "colin",
  #  :password => "colin",
  #  :host     => "mc32"  
    :adapter  => "oracle",
    :database => "drb",
    :username => "mcdbra3",
    :password => "mcdbra3",
    :host     => "colin-book"  
  )
end
class Test1 < ActiveRecord::Base
  self.table_name = 'AL'
end

def select_always
  i = 0
  while i < 120
    first = Test1.find(:first)
    puts "before:#{first.al_recid}"
    first.al_recid = Time.now.usec
    puts "after:#{first.al_recid}"
    
    puts "#{i}:#{first}"
    i += 1
  end
end
def fork_7
  establish_connection
  14.times do |i|
    pid = fork do
      ActiveRecord::Base.connection.reconnect!
      select_always
    end
    
  end
end
fork_7
p "ok"