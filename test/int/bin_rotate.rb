
def left_rotate(i,bit,right)
  front_part = i >> bit
  p ((1<<bit) -1)
  after_part = i & ((1<<bit) -1)
  after_part = after_part << right
  p front_part.to_s(2)
  p after_part.to_s(2)
  return (front_part | after_part)
end

i = 9
p i.to_s(2)
#front_part = i >> 1
#after_part = i & 1
#after_part = after_part << 3
#p front_part.to_s(2)
#p after_part.to_s(2)
#i = front_part | after_part
p left_rotate(i,2,2).to_s(2)

require 'digest/sha1' 
puts Digest::SHA1.hexdigest('1')