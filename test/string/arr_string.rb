str_arr = %w{jc1 mm2 colin3}
p str_arr

str_arr.each do |item|
  item='mmm'
end

p str_arr


int_arr = [1,2,3];
p int_arr
int_arr.each do |item|
  item+=1
end
p int_arr
class AA
  def initialize(str)
    @str = str 
  end
  def to_s
    "AA"+@str
  end
  def set_str(str)
    @str = str 
  end
end

aa_arr = [AA.new('jc1'),AA.new('jc2'),AA.new('jc3')]
p aa_arr
aa_arr.each do |item|
  item = AA.new('123')
end
p aa_arr

item = aa_arr[1]
item.set_str('456')
p aa_arr
p "ok"