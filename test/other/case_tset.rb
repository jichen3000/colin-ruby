def test_case(size)
  r = -1
  case size
  when 0 
  when 1
    r=1
  when 2 then
    begin
      r=2
      r+=1
    end
  # else也可以直接写
#  else r=99
  else 
    r=99
    r-=1
  end
  r
end

p test_case(0)
p test_case(1)
p test_case(2)
p test_case(3)
p "ok"