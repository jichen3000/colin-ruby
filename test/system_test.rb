#system("ipconfig",'/all')
720.times do |i|
	system("ps -ef|grep ruby >> applog/ora_backup_service.log")
	sleep(0.2)
end