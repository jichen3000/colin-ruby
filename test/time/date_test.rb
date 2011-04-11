require "date"
now = Date.today
p now
p now.to_s

start_day = Date.parse("2008-06-02")
p start_day
p start_day.to_s
p start_day.strftime('%Y%m%d')
p start_day.strftime('%y%m%d')
cnn_news_module = 'http://podcasts.cnn.net/cnn/services/podcasting/newscast/audio/%s/CNN-News-%s-5PM.mp3'
p cnn_news_module
cnn_news_addr = cnn_news_module % [start_day.strftime('%Y/%m/%d'),start_day.strftime('%m-%d-%y')]
p cnn_news_addr

step_days = now - start_day
p "step : #{step_days}"
ss = step_days % 2
p "ss : #{ss}"
case ss
when 0 then begin
  puts "0"
end  
when 1 then begin
  puts "1"
end  
end