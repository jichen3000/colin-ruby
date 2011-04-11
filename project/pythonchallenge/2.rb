path = File.dirname(__FILE__)
file = File.open(File.join(path,"2.txt"))
hash = {}
#line = file.readline
file.readlines.each do |line|
  line.each_byte do |b|
    if b != 10
      if hash[b]
        hash[b] += 1
      else
        hash[b]=1
      end
      puts b.chr if b>=97 and b<=122
    end
  end
end
p hash
arr = hash.sort{|a,b|a[1]<=>b[1]}
arr.each do |pare|
  puts pare[0].chr.to_s+"\t"+pare[1].to_s
end
# yqtiulae
# equality
p "ok"
