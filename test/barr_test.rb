def str2barr(str)
  arr = Array.new
  (str.size/2).times do |index|
    arr << str[2*index..(2*index+1)]
  end
  arr.pack("H2"*(arr.size))
end
def str16(i,just=2)
  i.to_i.to_s(16).rjust(just,'0').upcase
end
flag_str = "F1F2F3F4"
time_str = Time.now.strftime('%Y%m%d%H%M%S00')
index_str = str16(1,8)
write_barr = str2barr(index_str)+str2barr(time_str)+str2barr(flag_str)
p index_str+time_str+flag_str
p write_barr.size