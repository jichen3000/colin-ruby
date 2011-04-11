require 'test/unit'
require File.join(File.dirname(__FILE__),"s_base")
require 'httparty'
class Colin
  include HTTParty
#  base_uri 'http://172.16.4.98:8086'
  base_uri 'http://127.0.0.1:1234'
end


class SbTest < Test::Unit::TestCase
  def test_one
    t = Thread.new do
      MyApp.run! :host => '127.0.0.1', :port => 1234
    end
    sleep(3)
    options = {
      :body => {
          :action_desc_id => '999999', # your columns/data
          :target_type => 'Host', # your columns/data
          :target_id => '99999', # your columns/data
          :issue_type => 'PerformIssue', # your columns/data
          :issue_id => '999999', # your columns/data
          :issue_his_id => '99999' # your columns/data
      }
    }
    res = Colin.post('/mm',options)    
    p res
    sleep(2)
  end
end