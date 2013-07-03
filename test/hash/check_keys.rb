def check_hash_keys hash, keys
    bad_keys = hash.keys - keys
    raise "has more keys (#{bad_keys})" unless bad_keys.empty?
end

h = {jc: "jc", mm: "mm"}
p h

check_hash_keys(h, [:jc, :mm])
# check_hash_keys(h, [:jc])


Hash.class_eval do
    def check_keys keys
        bad_keys = self.keys - keys
        raise "has more keys (#{bad_keys})" unless bad_keys.empty?
    end
    
end
h.check_keys( [:jc, :mm])
h.check_keys( [:jc])
