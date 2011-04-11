require 'drb'

class DistCalc
	def find_distance(p1,p2)
		Math.sqrt((p1.x-p2.x)**2+(p1.y-p2.y)**2)
	end
end
class SystemRun
  def perform(sh_name,arg)
    system(sh_name,arg.join(" "))
  end
end
DRb.start_service("druby://jcbook:2223",DistCalc.new)
puts DRb.uri

DRb.thread.join