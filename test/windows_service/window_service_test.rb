# rubysrvc.rb
# gem install win32-service
# ���ļ�����ʹ��gbk����������������ڲ���serviceʱ��Ҳ�����������⡣
require 'rubygems' 
require "win32/service"
include Win32

# Create a new service
def create_service(service_name,rb_filename)
  Service.new(service_name, nil,
    :service_type       => Service::WIN32_OWN_PROCESS,
    :description        => 'A custom service I wrote just for fun',
#    :start_type         => Service::AUTO_START,
    :error_control      => Service::ERROR_NORMAL,
    :binary_path_name   => 'D:\tools\ruby\bin\ruby.exe '+rb_filename,
#    :load_order_group   => 'Network',
#    :dependencies       => ['W32Time','Schedule'],
#    :start_name => 'SomeDomain\\User',
#    :password           => nil,
    :display_name       => "colin's service2����"
  )
end

service_name = "colin_service2"
rb_filename = 'd:\file_service.rb'
#Service.services do |item| 
##   if item.service_name == service_name
#     p item
##     p "true"
##   end#end
Win32::Service.delete(service_name)

#create_service(service_name,rb_filename)
p "ok"
