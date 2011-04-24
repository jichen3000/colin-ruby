"123456".scan(/./) do |c|
  p c
end

p "split"
"123456".split(//).each do |c|
  p c
end



