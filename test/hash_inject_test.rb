def choose_weighted(weighted)
  sum = weighted.inject(0) do |sum, item_and_weight|
#    p sum,item_and_weight
    sum += item_and_weight[1]
  end
  target = rand(sum)
  weighted.each do |item, weight|
    return item if target <= weight
    target -= weight
  end
end

marbles = {  :white => 17 , :black => 51 , :yellow => 30}
10.times { puts choose_weighted(marbles) }
