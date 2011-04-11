a = ("a".."h").to_a
p a[8]
p a
p a[2..5]
p a[2...5]
p a[2,4]
p a.values_at(1, 0, -2)
p a.find_all { |x| x < "e" }
p a.reject { |x| x < "e" } 
p a.grep(/[aeiou]/)


#Union
p [1,2,3] | [1,4,5]                    # => [1, 2, 3, 4, 5] 

#Intersection
p [1,2,3] & [1,4,5]                    # => [1]

#Difference
p [1,2,3] - [1,4,5]   