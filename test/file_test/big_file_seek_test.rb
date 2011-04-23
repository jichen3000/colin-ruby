# 在windows中seek的最大值为2**30
# 在Linux中就没有这样的限制。
G2 = 2**31-1
37593088
def big_seek(file_name)
  file = File.new(file_name,'r')
  v_seek = G2 + 1
#  puts "v_seek : #{v_seek}"
#  puts "#{v_seek.integer?}"
#  puts "#{v_seek.class}"
#  puts "#{(G2-1).class}"
  if v_seek < G2
    file.seek(v_seek,IO::SEEK_CUR)
  else
    puts "v_seek < G2"
    v_time = v_seek / G2
#    puts v_time
    v_mod = v_seek % G2
    (v_time).times do |i|
      puts "i : #{i}"
      file.seek(G2,IO::SEEK_CUR)
    end
    file.seek(v_mod,IO::SEEK_CUR)
  end
  puts "seek is done"
  file.read(512)
  puts "read is done"
end
def big_seek_1(file_name)
  file = File.new(file_name,'r')
  v_seek = 1024*1024*1024*2 + 1
  puts "v_seek : #{v_seek}"
  if v_seek < G2
    file.seek(v_seek,IO::SEEK_CUR)
  else
    file.seek(v_seek,IO::SEEK_CUR)
    puts "seek ok!"
  end
  puts "seek is done"
  file.read(512)
  puts "read is done"
end

def big_seek_con(file_name)
  file = File.new(file_name,'r')
  v_seek = 1024*8*30
  puts "v_seek : #{v_seek}"
  file.seek(v_seek,IO::SEEK_CUR)
  
  v_seek = G2 - v_seek -1
  puts "v_seek : #{v_seek}"
  file.seek(v_seek,IO::SEEK_CUR)
  
  v_seek = 8*1024
  puts "v_seek : #{v_seek}"
  file.seek(v_seek,IO::SEEK_CUR)
  puts "seek is done"
  file.read(512)
  puts "read is done"
end

file_name = 'D:\temp\jc\USERS01.DBF'
file_name = ARGV[0] if ARGV.size>0

big_seek(file_name)
#big_seek_1(file_name)
big_seek_con(file_name)