require '../base_conn'
require 'test/unit'
require 'active_record/fixtures'

Fixtures.create_fixtures('./',:job_infos)

class TestJobInfo < Test::Unit::TestCase
  use_transactional_fixtures = true
  def test_simple
    mylog = Logger.new('mylog.txt')
    ActiveRecord::Base.logger = mylog
    #JobInfo.find_or_create_by_name('job_c1')
    #JobInfo.find_or_create_by_name('job_c2')
    
    j_arr = JobInfo.find :all
    assert_equal(j_arr.size,100)
  end
end
