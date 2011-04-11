require 'mongo'
db = Mongo::Connection.new("172.16.4.98").db("test")
p db
p db.collection_names
foo = db.collection('foo')
p foo.find_one
class ABC
  def initialize()
    @a = 1
    @b = 'c'
    @c = 2
  end
end
abc = ABC.new
p abc

foo.insert('abc' => ABC.new)
#p foo.find_all
p "ok"

