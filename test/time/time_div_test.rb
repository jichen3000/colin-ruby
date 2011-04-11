require 'test/unit'
class TestTime < Test::Unit::TestCase
  def test_time_div
    seconds = 2
    _start = Time.now
    p _start
    sleep(seconds)
    _end = Time.now
    p _end
    p (_end-_start).to_i
    assert(_end-_start == seconds)
  end
end