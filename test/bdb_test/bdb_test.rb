require 'bdb'

class BackupItem
  attr_reader :ol,
      :afn, :dba, :scn, :scn_wrap, :sequence, :flg, 
      :block_count, :rfn, :block_no,
      :afn_i, :dba_i
	def initialize(line)
		@dba, @afn = line.split(" ")
	end
end
require 'pp'
filename = "bdb_test.db"
db = BDB::Hash.create(filename,nil,BDB::CREATE)
line = '12345678 01'
bi = BackupItem.new(line)
pp bi
db[bi.afn] = bi.dba
pp db[bi.afn]
db.close
puts "create ok!"

db = BDB::Hash.open(filename,nil,'r')
pp db
pp db['01']
db.close
puts "read ok!"
