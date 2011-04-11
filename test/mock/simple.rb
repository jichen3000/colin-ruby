#
#class Track
#  def initialize
#    @step = 0
#  end
#  def move(steps)
#    @step += steps
#    p @step
#  end
#end
#
#class Tank
#  def initialize(left = Track.new, right = Track.new)
#    @left, @right = left, right
#  end  
#  def turn_right
#    @left.move(5)
#    @right.move( -5 )
#  end
#end
#
require 'mocha'
##Tank.new.turn_right
#left_track = mocha()
#right_track = mocha()
#tank = Tank.new(left_track,right_track)
#
#left_track.expects(:move).with(5)
#right_track.expects(:move).with(-5)
#
#tank.turn_right
# http://mocha.rubyforge.org/

duck = Mocha::Mock.new
duck.expects("mm").returns("ss")
p duck.mm
p duck.mm


#left_track.verify
#right_track.verify