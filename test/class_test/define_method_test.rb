class A
  define_method(:print_jc) {puts "jc"}  
  def create_method(name,&block)
    self.class.send(:define_method,name,&block)
  end
end

a = A.new
a.print_jc
a.create_method(:print_self) {puts self}
a.print_self

class Object
  def deep_copy
    Marshal.load(Marshal.dump(self))
  end
end
def guess(guess_point_map)
  guessed_result_arr = []
  x_index, y_index, group_index = guess_point_map[:index]
  guess_point_map[:possible_value].each do |possible_value|
    guess_object = deep_copy(self)
    guess_object.add_answer_value(possible_value, x_index, y_index, group_index, 'guess')
    answer_flag, next_guess_point_map, next_result_map = guess_object.answer()
    if answer_flag == 'logic error'
      puts "ksdf"
      puts "#{answer_flag} : #{next_result_map}"
    elsif answer_flag == 'need guess'
      puts "#{answer_flag} : #{guess_point_map}"
      guessed_result_arr += guess_object.guess(next_guess_point_map)
    elsif answer_flag=='answered'
      puts "#{answer_flag}"
      guessed_result_arr << next_result_map
    end
  end
  guessed_result_arr
end
