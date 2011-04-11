require "base_conn"

ji = JobInfo.find_or_create_by_name("delete_test")
p ji

#JobInfo.delete_all(:name=>"delete_test")
#JobInfo.destroy_all(:name=>"delete_test")
ji.destroy
ji.name = "dt"

p ji

p "ok"
