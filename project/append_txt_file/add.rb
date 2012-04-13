def append_files(target, source)
  tfile = File.new(target,'w')
  if not source.kind_of?(Array)
    source_arr = []
    Dir.open(source).each do |item|
      if not (item=='.' or item=='..')
        source_arr << File.join(source,item)
      end
    end
  end
  source_arr.each do |item|
    sfile = File.open(item,'r')
    content = sfile.readlines
    tfile << content
    tfile << "\n"
    puts "file(#{sfile.path}) had added!"
    sfile.close
  end
  puts "file(#{tfile.path}) had generated!"
  tfile.close
end

target = 'D:\books\novel\村上春树作品TXT全集\海边的卡夫卡.txt'
#source = ['D:/tmp/1.txt','D:/tmp/2.txt']
source = 'D:\books\novel\村上春树作品TXT全集\海边的卡夫卡'
p target
p source
require 'iconv'
i=Iconv.new('gbk','utf-8')
target=i.iconv(target)
source=i.iconv(source)
append_files(target, source)
puts "ok"