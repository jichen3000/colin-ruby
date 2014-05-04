

source_list = %w(东京_大阪 大阪_广岛 广岛_博多 博多_鹿儿岛 鹿儿岛_姬路 姬路_京都 京都_奈良 奈良_高野山 高野山_大阪 大阪_关机机场)

target_list = source_list.map do |item|
    ["- " + item,
        "![#{item}_train01](./japan-route-sources/#{item}_train01.png)",
        "![#{item}_train02](./japan-route-sources/#{item}_train02.png)", ""]
end

puts source_list
puts target_list