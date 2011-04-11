    def str2barr(str)
      arr = Array.new
      (str.size/2).times do |index|
        arr << str[2*index..(2*index+1)]
      end
      arr.pack("H2"*(arr.size))
    end
s = "0123456e"
#s.each {|i| puts i+""}
arr = str2barr(s)
#arr = s.pack('H8')
p arr