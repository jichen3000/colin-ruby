collection = [1, 2, 3, 4, 5]
p collection.inject(0) {|sum, i| sum + i} 
p collection.inject(1) {|sum, i| sum * i} 

p collection.min
p collection.max


collection = [ [1, 'one'], [2, 'two'], [3, 'three'],
                 [4, 'four'], [5, 'five'] 
               ]
ahash = collection.inject({}) do |hash, value|
    hash[value.first] = value.last 
    hash
end


p ahash

bhash = collection.dup.inject({}) { |hash, value| hash.update value.first => value.last  }
p bhash

