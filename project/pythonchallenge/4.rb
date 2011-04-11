require "open-uri"

def get_numstr(url,num_str)
  file = open(url+num_str)
  line = file.readline
  puts line
  if line!="Yes. Divide by two and keep going."
    while not (line =~ /(\d+)$/)
      line = file.readline
      puts line
    end
  else
    return (num_str.to_i/2).to_s
  end
  return $1 
#  line = file.readline
#  puts "jc11 "+line
#  line =~ /(\d+)$/
#  puts "jc"+$1
#  $1
end


url = 'http://www.pythonchallenge.com/pc/def/linkedlist.php?nothing='
num_str = 92118.to_s
400.times do |i|
  num_str = get_numstr(url,num_str)
  puts i.to_s+"\t"+num_str
end

#line = "There maybe misleading numbers in the text. One example is 61067. Look only for the next nothing and the next nothing is 53522"
#line = "There maybe misleading numbers in the text. One example is 61067"
#line =~ /(\d+)$/
#puts $1,$2

# http://www.pythonchallenge.com/pc/def/peak.html