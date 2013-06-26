require 'state_machine'

class TrafficLight
  state_machine :initial => :stop do
    event :cycle do
      transition :stop => :proceed, :proceed => :caution, :caution => :stop
    end
  end
end

tl = TrafficLight.new
p tl.state # stop
tl.cycle
p tl.state_name # proceed
tl.cycle
p tl.human_state_name # caution
