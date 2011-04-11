# must install 'ruby-amazon'
require 'amazon/search'

access_key = '1ABGMC4THP9F383DZNR2'
#access_key = 'Fib94Ml6ZQ4JfpN+0C50tfSyX1XssPLgDlco4yEo'
search_request = 'restful web service'

req = Amazon::Search::Request.new(access_key)

req.keyword_search(search_request,'books',Amazon::Search::LIGHT) do |book|
  puts "book name: #{book.product_name} by #{book.authors.join(',')}"  
end

