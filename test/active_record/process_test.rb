require 'activerecord'

ActiveRecord::Base.establish_connection(
  :adapter  => "oracle_enhanced",
  :database => "drb",
  :username => "mcdbra",
  :password => "mcdbra"
)
class Issue < ActiveRecord::Base
  self.table_name = 'MC$dr_system'
end


def main
  2.times do |x|
    @pid = fork do
      Signal.trap("HUP") do
        @pid=nil
        exit
      end
      index = 0
      while true
        issue=Issue.first
        p "sub#{index},issue:#{issue}"
        sleep(1)
        index += 1
      end
    end
  end
  index = 0
  while true
    issue=Issue.first
    p "i#{index},issue:#{issue}"
    sleep(1)
    index += 1
  end
end

main
p "ok"