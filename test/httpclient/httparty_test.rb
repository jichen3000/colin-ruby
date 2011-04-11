require 'httparty'

class Colin
  include HTTParty
  base_uri 'http://172.16.4.98:8086'
#  base_uri 'http://127.0.0.1:2345'
end


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
#options = {
#  :actions => {
#    :body => {
#        :action_desc_id => '999999', # your columns/data
#        :target_type => 'Host', # your columns/data
#        :target_id => '99999', # your columns/data
#        :issue_type => 'PerformIssue', # your columns/data
#        :issue_id => '999999', # your columns/data
#        :issue_his_id => '99999' # your columns/data
#    }
#  }
#}

res = Colin.post('/action', options)
res = Colin.post('/mm',options)
#res = Colin.post('', options)
p res
p res.response
p res.parsed_response
p "ok"