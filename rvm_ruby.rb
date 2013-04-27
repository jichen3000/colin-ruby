#!/usr/bin/env ruby

file = File.expand_path(ARGV[0] || (STDERR.puts('you must specify a ruby file'); exit(-1)))
dir = File.dirname file
while dir.size > 1
  puts "dir: #{dir}"
  if File.exist?(dir + '/.rvm')
    exec("source \"$HOME/.rvm/scripts/rvm\"; cd #{dir}; ruby #{file}")
  else
    dir = dir.sub(/\/[^\/]*$/, '')
  end
end

puts "Could not find any .rvmrc above #{file}"
exit -1
