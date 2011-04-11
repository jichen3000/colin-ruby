def sub_length(str,length)
  if str.length > length
    return str[0,length]
  end
  return str
end

test = '1234567890'

p sub_length(test,5)
p sub_length(test,10)
p sub_length(test,20)