require 'base_conn'

#new_ji = JobInfo.new
#new_ji.name = "mm"
#new_ji.first_time = Time.now
#new_ji.save
#new_ji = JobInfo.find_by_name("mm")

#new_ji = JobInfo.create(:name=>"create_1", :first_time=>Time.now)

#p new_ji.id.to_i
#p JobInfo.find(:all)
#p JobInfo.find(23,25)

# 子对象保存时，父对象也会保存。
#new_ji = JobInfo.new
#new_ji.name = "c_t"
#new_ji.first_time = Time.now
#
#new_li = LogInfo.new
#new_li.name = "c_t"
#new_li.job_info = new_ji
#new_li.save

# 父对象保存时，子对象也会保存。
#new_ji = JobInfo.new
#new_ji.name = "c_t"
#new_ji.first_time = Time.now
#
#new_li = LogInfo.new
#new_li.name = "c_t"
#
#new_ji.log_infos << new_li
#new_ji.save


# 删除创建的对象
JobInfo.destroy_all(:name=>"c_t")
LogInfo.destroy_all(:name=>"c_t")
p "ok"
