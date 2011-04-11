a = "AlassZame"
def change(class_name)
  str = ""
  class_name.each_byte do |b|
    if b >= 65 and b<=90
      str << "_" if str.length>0
      str << b +32
    else
      str << b
    end
  end
  return str
end

puts change(a)
puts "ok"