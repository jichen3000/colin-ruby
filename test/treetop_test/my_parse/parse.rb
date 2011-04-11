STRING_REPLACEMENT_TOKEN =  "___+++STRING_LITERAL+++___"
def extract_string_literals( string )
  string_literal_pattern = /"([^"\\]|\\.)*"/
  # Find and extract all the string literals
  string_literals = []
  string.gsub(string_literal_pattern) {|x| string_literals << x}
  # Replace all the string literals with our special placeholder token
  string = string.gsub(string_literal_pattern, STRING_REPLACEMENT_TOKEN)
  # Return the modified string and the array of string literals
  return [string, string_literals]
end
def tokenize_string( string )
  string = string.gsub("("," ( ")
  string = string.gsub(")"," ) ")
  return string.split(" ")
end
def restore_string_literals(token_array, string_literals)
  return token_array.map do |x|
    if x==STRING_REPLACEMENT_TOKEN
      string_literals.shift
    else
      x
    end
  end
end
def is_match?(string, pattern)
  match = string.match(pattern)
  return false unless match
  # Make sure that the matched pattern consumes the entire token
  match[0].length == string.length
end
def is_symbol?(string)
  return is_match?(string,/[^\"\'\,\(\)]+/ ) 
end
def is_integer_literal?(string)
  return is_match?(string,/[\-\+]?[0-9]+/ ) 
end
def is_string_literal?(string)
  return is_match?(string, /"([^"\\]|\\.)*"/ ) 
end
def convert_tokens( token_array )
  converted_tokens = []
  token_array.each do |t|
    converted_tokens << "(" and next if( t == "(" )
    converted_tokens << ")" and next if( t == ")" )
    converted_tokens << t.to_i and next if( is_integer_literal?(t) )
    converted_tokens << t.to_sym and next if( is_symbol?(t) )
    converted_tokens << eval(t) and next if( is_string_literal?(t) )
    # If we haven't recognized the token by now we need to raise
    # an exception as there are no more rules left to check against!
    raise Exception, "Unrecognized token: #{t}"
  end
  return converted_tokens
end
def re_structure( token_array, offset = 0 )
  struct = []
  while( offset < token_array.length )
    if(token_array[offset] == "(")
      # Multiple assignment from the array that re_structure() returns
      offset, tmp_array = re_structure(token_array, offset + 1)
      struct << tmp_array
    elsif(token_array[offset] == ")")
      break
    else
      struct << token_array[offset]
    end
    offset += 1
  end
  return [offset, struct]
end
def parse( string )
  # 将内部的字符串进行替换
  string, string_literals = extract_string_literals( string )
  # 用空格来分割
  token_array = tokenize_string( string )
  # 将内部字符串替换回去
  token_array = restore_string_literals( token_array, string_literals )
  # 生成对应的对象
  token_array = convert_tokens( token_array )
  # 重组结构
  s_expression = re_structure( token_array )[1]
  return s_expression
end
def main(string)
  string = '"123 this" 123 "that" (lll  45)'
  string,string_literals = extract_string_literals(string)
  p string,string_literals
  token_array = tokenize_string(string)
  p token_array
  s_arr = restore_string_literals(token_array, string_literals)
  p s_arr
  p " sdf"
  c_arr = convert_tokens(s_arr)
  p c_arr
  p "re -struct"
  p re_structure(c_arr)[1]
#  p Regexp.new(/[^\"\'\,\(\)]+/)
#  p Regexp.new(/"([^"\\]|\\.)*"/)
end

p main('(this (is a number 1( example "s-expression")))')
p "ok"
