require 'pp'

def str_time(time)
  time.strftime('%Y-%m-%d %H:%M:%S ')+' '+time.usec.to_s
end
now = Time.now
puts now
puts now.to_s
puts now.strftime('%Y%m%d%H%M%S')
puts now.zone
puts str_time(now)
puts now.usec
puts now.isdst
#puts now.gmtime
#puts now


def china_time(time)
  wday=["��","һ","��","��","��","��","��"]
  time.year.to_s+'��'+time.month.to_s+"��"+time.day.to_s+"��"+" "+ 
    time.hour.to_s+"��"+ time.min.to_s+"��"+time.sec.to_s+"��"+
    " ����"+ wday[time.wday]
end
def china_time2(time)
  wday=["��","һ","��","��","��","��","��"]
  time.strftime("%Y��%m��%d�� %H��%M��%S�� ����")+wday[time.wday]
end
str = '2007-9-16-13-13'
arr = str.split("-").map{|x| x.to_i}
t = Time.mktime(arr[0],arr[1],arr[2],arr[3],arr[4])

add_days = 10
add_secs = add_days * 24 * 3600
p t
ano = t+add_secs
puts china_time(t)
puts china_time2(t)
puts china_time(ano)
puts china_time2(ano)

