# rubysrvc.rb
# gem install win32-service
# 本文件必须使用gbk，否则就算是中文在插入service时，也会有乱码问题。
require 'rubygems' 
require "win32/service"
include Win32

service_name = "colin_service"
rb_filename = 'd:\file_service.rb'
#Service.services do |item| 
##   if item.service_name == service_name
#     p item
##     p "true"
##   end
#end
Win32::Service.delete(service_name)

#create_service(service_name,rb_filename)
p "ok"
