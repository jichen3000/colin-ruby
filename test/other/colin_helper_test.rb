require 'colin_helper'
require 'test/unit'
require 'pp'
class ColinHelperTest < Test::Unit::TestCase
  def setup
    @arr=['af','12','78','12']
    @barr=[234,13,45,89,23]
    @barr1=[234,2,1]
    @str = 255
    @i = 100
    @str_barr = "1600000C"
#    @str_barr = "0a"
  end
	def test_count_seconds()
		start_time = Time.mktime(2007,9,19,16,0,0)
		puts ColinHelper.str_time(start_time)
		sec = ColinHelper.count_seconds(start_time,6)
		puts sec
		puts sec.to_f/3600
    p ColinHelper.str16(@i,8)
    p ColinHelper.str2barr(@str_barr)
	end
#  def test_barr2str16
#    puts ColinHelper.barr2str16(@str)
#  end
#  def test_barr2int
##    puts ColinHelper.barr2int(@str)
#  end
#  def test_round4
##    a = 4
##    a += ColinHelper.round4(5)
##    puts a.to_s
#  end
#  def test_read_block
##    puts ColinHelper.read_block(@arr,1,2)
##    puts ColinHelper.read_block(@barr,1,2,false)  
#  end
end
