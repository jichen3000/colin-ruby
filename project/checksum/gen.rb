str = "    block_16[%1] = block_16[%1] ^ block[16*i+%1];"
16.times do |i|
  puts str.gsub("%1",i.to_s)
end