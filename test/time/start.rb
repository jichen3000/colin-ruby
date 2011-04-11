now = Time.now
t20 = Time.local(now.year, now.month, now.day, 19,0,0)
program = 'D:\tools\Thunder\Thunder.exe'
p t20
seconds = t20-now
p seconds
sleep(seconds)
p system(program)
p "ok"