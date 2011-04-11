require "colin_helper"

class HashTest
  @@seed = 10000
  def initialize(count,slip_count)
    @count = count 
    @slip_count = slip_count
    
    @hash_arr = []
  end
  def gen()
    @count.times do |i|
      puts "#{i} has created" if i % @slip_count == 0 
      add_hash_item(i,@@seed)
    end
  end
  def add_hash_item(index,seed)
    size = rand(seed)
    hash_item = {:index => index, :size => size, :content => 'A'*size}
    @hash_arr << hash_item
  end
  def gen_check(check_count)
    @check_count = check_count
    @count.times do |i|
      puts "#{i} has created" if i % @slip_count == 0 
      add_check_hash_item(i,@@seed)
    end
  end
  def add_check_hash_item(index,seed)
    if @hash_arr.size > @check_count
      @hash_arr.each {|item| item = nil}
    end
    size = rand(seed)
    hash_item = {:index => index, :size => size, :content => 'A'*size}
    @hash_arr << hash_item
  end
end

count = 40*10000
slip_count = 10000
check_count = 10000
count = 10000
slip_count = 1000
check_count = 1000
func = 'gen_check'
count = ARGV[0].to_i if ARGV.size > 0
slip_count = ARGV[1].to_i if ARGV.size > 1
check_count = ARGV[2].to_i if ARGV.size > 2
func = ARGV[3].to_i if ARGV.size > 3

start_time=Time.now
puts( 'App Start! time: '+ColinHelper.str_time(start_time))

ht = HashTest.new(count,slip_count)
if func == 'gen' 
  ht.gen
else
  ht.gen_check(check_count)
end

end_time=Time.now
puts( 'App End! time: '+ColinHelper.str_time(end_time))
puts( 'Through '+(end_time-start_time).to_f.to_s+' seconds!')
puts("create #{count} objects")
