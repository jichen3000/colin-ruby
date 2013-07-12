class Person
    TTT = "123"
    class Colin
    end
end

# P Person.const_get（“TTT”）
p Object.const_get(:Person)

p Object.const_get("Person").const_get("Colin").new

def class_from_string(str)
  str.split('::').inject(Object) do |mod, class_name|
    mod.const_get(class_name)
  end
end

p class_from_string("Person::Colin")
p class_from_string("Person")
p Person

