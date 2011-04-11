#int i=5;  
#1  2  3  4  5  
#16 17 18 19 6  
#15 24 25 20 7  
#14 23 22 21 8  
#13 12 11 10 9  
#int i=6  
#1  2  3  4  5   6  
#20 21 22 23 24  7  
#19 32 33 34 25  8  
#18 31 36 35 26  9  
#17 30 29 28 27 10  
#16 15 14 13 12 11

class Square
  def self.init_arr(size)
    arr = []
    size.times do |i|
      arr[i]=[]
      size.times do |j|
        arr[i][j]=0
      end
    end
    arr
  end
  def self.perform(size)
    m,k = 0,0
    arr = init_arr(size)
    max = size*size
    if size.odd?
      arr[size/2][size/2] = max
      # 为了及时的退出
      max = max - 1
    end
    while(m*2 <= size)
      i = m
      m.upto(size-m-2) do |j|
        # test
        puts "i=#{i},  j=#{j}"
        puts "k+1=#{k+1}"
        arr[i][j] = k+1
        p arr
        k += 1
      end
      break if k >= max
      # test
      puts ""
      
      j = size - m - 1
      m.upto(size-m-2) do |i|
        # test
        puts "i=#{i},  j=#{j}"
        puts "k+1=#{k+1}"
        arr[i][j] = k+1
        p arr
        k += 1
      end
      break if k >= max
      # test
      puts ""
      
      i = size - m - 1
      (size-m-1).downto(m+1) do |j|
        # test
        puts "i=#{i},  j=#{j}"
        puts "k+1=#{k+1}"
        arr[i][j] = k+1
        p arr
        k += 1
      end
      break if k >= max
      # test
      puts ""
      
      j = m
      (size-m-1).downto(m+1) do |i|
        # test
        puts "i=#{i},  j=#{j}"
        puts "k+1=#{k+1}"
        arr[i][j] = k+1
        p arr
        k += 1
      end
      break if k >= max
      # test
      puts ""
      m += 1
    end
    puts "middle:#{size/2}"
    arr.flatten
  end
end  
require 'test/unit'
class TestSquare < Test::Unit::TestCase
  def test_perform
    assert_equal([1,2,4,3],Square.perform(2))
    assert_equal([1,2,3,8,9,4,7,6,5],Square.perform(3))
    assert_equal([1,2,3,4,5,
                  16,17,18,19,6,
                  15,24,25,20,7,
                  14,23,22,21,8,
                  13,12,11,10,9],Square.perform(5))
  end
  def test_init_arr
    assert_equal([[0,0],[0,0]],Square.init_arr(2))
  end
end