require 'sqlite3'
require 'sequel'
require 'pp'

db_filename = File.join(File.dirname(__FILE__),'simple.db')
db = Sequel::sqlite(db_filename)

pp db[:people].all
pp db[:roles].all
  
p "ok"