class GuessNumber
  GUESS_TIMES = 6
  class << self
    def perform
      gn = GuessNumber.new
      gn.perform
    end
  end
  def perform
    guess_result = ""
    p "generate_number_arr"
    n_arr = generate_number_arr
#    p n_arr
    GUESS_TIMES.times do |index|
      puts "This #{index+1} time, you still have #{GUESS_TIMES-index-1} times."
      g_arr = get_input_arr
#      p g_arr
      guess_result = match_numbers(g_arr,n_arr)
      p guess_result
      if guess_result == '4A'
        puts n_arr.join
        puts "You Win!"
        break
      end
    end
    if guess_result != '4A'
      puts n_arr.join
      puts "You Loss!"
    end
  end  
  def generate_number_arr
    a_arr = [0,1,2,3,4,5,6,7,8,9]
    n_arr = []
    4.times do |i|
      n_arr << a_arr.delete_at(rand(a_arr.size))
    end
    n_arr    
  end
  def get_input_arr
    puts "Input guess numbers(4 numbers):"
    l = gets
    l.to_s.chomp!.split("").map!{|i| i.to_i}
    
  end
  def check_arr(arr)
    if arr.size != 4
      raise "length is must 4!"
    end    
    Integer(arr.join)
    if arr.uniq.size != 4
      raise "has repeat number!"
    end
  end
  def match_numbers(guess_arr,n_arr)
    a = 0
    b = 0
    guess_arr.each_with_index do |item,index|
      if n_arr.index(item)
        if n_arr.index(item) == index
          a += 1
        else
          b += 1
        end
      end
    end
    r = ""
    r += a.to_s + "A" if a > 0
    r += b.to_s + "B" if b > 0
    r = "no match" if r == ""
    r
  end
end

GuessNumber.perform
p "ok"