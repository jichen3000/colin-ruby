# https://deveo.com/blog/2013/03/28/immutability-in-ruby-part-2/

# string is mutable, but integer and symbol are immutable.
# http://markmail.org/message/cgrfvsncmko5ae7c#query:+page:1+mid:w273xdhvwqu5htgl+state:results

# rough immutable string.
str = "abc"
str.freeze
# str << "d" # it will report error
p str


# hash and array are also mutable, but there many mehtods of them will return a new object, 
# map, select, take for instance.
# Moreover, in ruby 2.0, laziness will improve the preformance.
a = [1,2,3]
b = a.lazy.
  map    { |n| n * n }.
  select { |n| n.odd? }.
  take(2)
b.each {|x| puts x}

# hamster will give you the immutable list, hash, set ...

# The classes in our domains can be divided into two different groups: Values and Objects.

# Values are things that are defined in terms of their contents (or “state”) - like the number 42. 
# Values are immutable: We can’t change 42 to be something else, 
# as we discussed in the previous post.
# A compound object may also be a value. 


# Objects are things that have an Identity, and may have different values over time. 
# Have an identity (e.g. “id”).

# Immutability is a transitive property in this sense. 
# If anything within an object graph is mutable, the whole object graph is mutable.
