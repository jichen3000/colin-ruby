#ActionMailer::Base.server_settings = {
#}
require 'rubygems'
require 'thread'
require 'action_mailer'
ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.default_charset = "utf-8"
ActionMailer::Base.delivery_method = :smtp 
ActionMailer::Base.template_root = File.dirname(__FILE__)
ActionMailer::Base.smtp_settings = {  
 :address => "smtp.ym.163.com",  
 :port => 25,  
# :authentication => :login,  
 :user_name => "jic@mchz.com.cn",  
 :password => "780602",
 :domain => "mchz.com.cn"
} 

class InfoMailer < ActionMailer::Base

#  def send(msg,to)
#    @subject    = 'DBRA灾备系统通知'
#    @body["msg"]  = msg
#    @recipients = to
#    @from       = 'dbra-admin@mchz.com.cn'
#    @sent_on    = Time.now.strftime("%Y-%m-%d %H:%M")
#    @headers["DBRA system"]    = "杭州美创科技有限公司"
##    @content_type = "text/html"
#  end
  
#  def signup_notification(msg,to,msg1)
#    recipients   to
#    subject      'DBRA灾备系统通知'
#    from         "jic@mchz.com.cn"
#    headers["DBRA system"]    = "杭州美创科技有限公司"
#    body["msg"]    =msg
#    body["msg1"] =msg1
#    content_type "text/html"
#  end
  def signup_colin(msg_hash,to)
    recipients   to
    subject      'DBRA灾备系统通知'
    from         "jic@mchz.com.cn"
    headers["DBRA system"]    = "杭州美创科技有限公司"
    body["msg_hash"]    =msg_hash
    content_type "text/html"
  end
end

#im = InfoMailer.new
#InfoMailer.deliver_send("tset action mailer2 <sdfsdfdsfd", "jic@mchz.com.cn")
require 'cgi'
#InfoMailer.deliver_signup_notification(
#  CGI::escapeHTML("tset action mailer2 <sdfsdfdsfd"),"jic@mchz.com.cn",'lll')
InfoMailer.deliver_signup_colin(
  {"m1"=>CGI::escapeHTML("tset action mailer2 <sdfsdfdsfd"), "m2"=>"111"},
  "jic@mchz.com.cn")
p "ok"
