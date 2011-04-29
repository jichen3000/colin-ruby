filename = '/home/dbra/colin/uid_test.rb'
filename = ARGV[0] if ARGV.size > 0
p "filename : #{filename}"
p File.lstat(filename).mode
p (File.lstat(filename).mode & 0777)

#File.fancy_chmod("u+x", filename)
#p (File.lstat(filename).mode & 0777)

p "ok"