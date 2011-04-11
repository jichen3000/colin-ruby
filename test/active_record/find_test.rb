require 'base_conn'

#LogInfo.create(:name=>"arc_1_11.dbf", :create_time=>Time.now, :status=>"A")
#LogInfo.create(:name=>"arc_1_12.dbf", :create_time=>Time.now, :status=>"A")
#LogInfo.create(:name=>"arc_1_13.dbf", :create_time=>Time.now, :status=>"A")
#LogInfo.create(:name=>"arc_1_14.dbf", :create_time=>Time.now, :status=>"A")

li_arr = LogInfo.find(:all)
#
#p li_arr
#
#ji_arr = JobInfo.find(:all)
#li_arr[0].job_id = ji_arr[0].id
#li_arr[1].job_id = ji_arr[0].id
#li_arr[2].job_id = ji_arr[1].id
#li_arr[3].job_id = ji_arr[1].id
#

#li_arr.each_with_index do |item,index|
#  if index % 2 == 0
#    item.applied = "Y"
#  else 
#    item.applied = "N"
#  end
#  item.save  
#end

lis = LogInfo.find(:all, :include=>{:job_info=>{}}, 
  :conditions=>["job_infos.status = ?","A"])

p lis

p "ok"