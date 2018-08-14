#!/usr/bin/env ruby
# -v  -- print the Ruby version
# -w  -- warn on syntax errors
# -W2 -- warning set the warning level to 2 (verbose)
a = [1,2,3]
b = [4,5,6,7]
c = a | b
p c

a = [1,2,3]
b = ["4","5"]
c = a | b
p c
