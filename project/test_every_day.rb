require 'every_day'
require 'test/unit'

class TestEveryDay < Test::Unit::TestCase
  def setup
  end
  def test_open_firefox
#    ed = EveryDay.perform_test(EveryDay::OFFICE_TYPE)
#    url1="http://www.google.cn"
#    url2="http://www.sina.com.cn"
#    ed.open_firefox([url1,url2])
  end
  def test_perform
    EveryDay.perform(EveryDay::OFFICE_TYPE)
  end
end
