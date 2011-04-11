require 'base_conn'


lis = JobInfo.find(:all, :limit=>3, :offset=>2)
lis.each {|item| p item}
p "ok"
