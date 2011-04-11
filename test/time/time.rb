require "date"
a = Date.parse("2008-06-02")
puts Time.now.strftime('%Y-%m-%s %H:%M:S')
p a
p Time.now.strftime('%m-%d-%y')
puts "ok"
p Time.parse("")