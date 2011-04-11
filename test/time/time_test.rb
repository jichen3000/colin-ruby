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
  wday=["天","一","二","三","四","五","六"]
  time.year.to_s+'年'+time.month.to_s+"月"+time.day.to_s+"日"+" "+ 
    time.hour.to_s+"点"+ time.min.to_s+"分"+time.sec.to_s+"秒"+
    " 星期"+ wday[time.wday]
end
def china_time2(time)
  wday=["天","一","二","三","四","五","六"]
  time.strftime("%Y年%m月%d日 %H点%M分%S秒 星期")+wday[time.wday]
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

