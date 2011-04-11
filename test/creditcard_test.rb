require 'rubygems' 
require 'creditcard'
# gem install creditcard --include-dependencies

puts '5276 4400 6542 1319'.creditcard?    # => true
puts '4392 2500 1326 8361'.creditcard?    # => true
puts '5276440065421313'.creditcard?       # => false
puts 5276440065421319.creditcard?         # => false
