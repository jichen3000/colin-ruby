def str2barr(str)
  arr = Array.new
  (str.size/2).times do |index|
    arr << str[2*index..(2*index+1)]
  end
  arr.pack("H2"*arr.size)
end
def barr2str16(b_arr,len = nil)
  len ||= 2*b_arr.length
  b_arr.unpack('H'+(len).to_s).join.upcase
end
def fill_arr(arr,size)
  return if arr.size >= size
  len = size - arr.size
  (len).times do |i|
    arr << "00"
  end
  arr
end
def gen_block(block_size)
  i_arr = ["23","45","96","99"]
  fill_arr(i_arr,block_size-4)
  after_arr = ["99","99","33","01"]
  i_arr += after_arr
  i_arr.pack("H2"*i_arr.size)
end
def gen_block_o(block_size)
  s = "12345678" + "00"*(block_size-8) + '9988a766'
  str2barr(s)
end
def gen_block2(black_block)
  pre_arr = ["23","45","96","99"]
  pre_arr.pack("H2"*pre_arr.size)
  after_arr = ["99","99","A9","01"]
  after_arr.pack("H2"*after_arr.size)
  pre_arr + black_block + after_arr
end
def file_write(file)
  i_arr = ["2300","4500","9600"]
  fill_arr(i_arr,1024)
  block = i_arr.pack("H2"*i_arr.size)
  puts barr2str16(block)
  
  file.write(block)
end

block_size = 512
wf = File.new("d:/work/testdata/test1.dbf","rb+")
while not wf.eof?
  block = wf.read(block_size)
end
block = gen_block_o(block_size)
wf.write(block)
wf.close
#stime = Time.now
#black_block = fill_arr([],block_size-8)
#block = nil
#10000.times do |i|
##  gen_block(block_size)
#block = gen_block2(black_block)
#end
#p "array size : #{block.size}"
#etime = Time.now
#p "time secs: #{(etime-stime).to_s}"
p "ok"

