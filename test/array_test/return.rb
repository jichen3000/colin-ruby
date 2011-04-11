def test
  arr = [1,2,3]
  arr.each do |item|
    if item == 2
      return 100
    end
    puts item
  end
end

p test