class TimeHelper
  class << self
    def is_odd(date,start_date)
      ((date - start_date).to_i % 2) == 1
    end
    def colin_str_time(time)
      result = time.strftime('%Y-%m-%d %H:%M:%S')
      if time.respond_to?(:usec)
        result += ' '+time.usec.to_s
      end
      result
    end
    def is_last_first_mday(date)
      date.mday == 1 || date.next.mday == 1 
    end
    def is_weekend(date)
      date.cwday == 6 || date.cwday == 7
    end
  end
end

require 'test/unit'
class TestTimeHelper < Test::Unit::TestCase
  def setup
    @odd_day = Date.parse("2009-02-28")
    @even_day = Date.parse("2009-02-27")
    @mlast_day = Date.parse("2009-02-28")
    @mfirst_day = Date.parse("2009-03-01")
    @start_day = Date.parse("2008-06-02")
    @saturday = Date.parse("2009-02-28")
    @sunday = Date.parse("2009-03-01")
    @time = Time.mktime(2009,2,28,12,13,14,123456)
  end 
  def test_is_odd
    assert(TimeHelper.is_odd(@odd_day, @start_day))
#    p TimeHelper.is_odd(@odd_day, @start_day)
  end
  def test_colin_str_time
    assert_equal(TimeHelper.colin_str_time(@odd_day),"2009-02-28 00:00:00")
    assert_equal(TimeHelper.colin_str_time(@time),"2009-02-28 12:13:14 123456")
    p TimeHelper.colin_str_time(@time)
#    p TimeHelper.colin_str_time(@odd_day)
#    p TimeHelper.colin_str_time(@time)
#    p TimeHelper.colin_str_time(Time.now)
  end
  def test_is_last_first_mday
    assert(TimeHelper.is_last_first_mday(@mlast_day))
    assert(TimeHelper.is_last_first_mday(@mfirst_day))
  end
  def test_is_weekend
    assert(TimeHelper.is_weekend(@saturday))
    assert(TimeHelper.is_weekend(@sunday))
  end
end