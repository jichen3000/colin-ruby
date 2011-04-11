require "colin_helper"
class ObjectTest
  def initialize(index,seed)
    set(index,seed)
  end
  def set(index,seed)
    @index = index
    @size = rand(seed)
    @content = 'A'*@size
  end
end

class ObjectTestArr
  def initialize
    @o_arr = []
    @check_count = 10000
  end
  def gen(count,slip_count)
    count.times do |index|
      puts "#{index} has created" if index % slip_count == 0 
      cur_ot = ObjectTest.new(index,1000)
      @o_arr << cur_ot
    end
  end
  def gen_check(count,slip_count,check_count)
    @check_count = check_count
    count.times do |index|
      puts "#{index} has created" if index % slip_count == 0 
      add_ot(index,1000)
    end
  end
  def add_ot(index,seed)
    if @o_arr.size < @check_count
      cur_ot = ObjectTest.new(index,1000)
      @o_arr << cur_ot
    else
      cur_index = index % @check_count
      @o_arr[cur_index].set(index,1000)
    end
  end
end

count = 40*10000
slip_count = 10000
check_count = 10000
count = 10000
slip_count = 1000
check_count = 100
count = ARGV[0].to_i if ARGV.size > 0
slip_count = ARGV[1].to_i if ARGV.size > 1
check_count = ARGV[2].to_i if ARGV.size > 2

start_time=Time.now
puts( 'App Start! time: '+ColinHelper.str_time(start_time))
ota = ObjectTestArr.new 
ota.gen_check(count,slip_count,check_count)

end_time=Time.now
puts( 'App End! time: '+ColinHelper.str_time(end_time))
puts( 'Through '+(end_time-start_time).to_f.to_s+' seconds!')
puts("create #{count} objects")

