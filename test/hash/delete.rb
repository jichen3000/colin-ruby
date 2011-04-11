require 'active_support'

hash = {"name"=>"jc","id"=>1,"desc"=>"jcjcjcjcj"}
p hash
hash.reject! {|key,value| key!="name"}
p hash
p hash.to_json

p "ok"