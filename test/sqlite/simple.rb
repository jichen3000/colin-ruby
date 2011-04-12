require 'sqlite3'

db_filepath = File.join(File.dirname(__FILE__),"simple.db")
db = SQLite3::Database.new(db_filepath)

# Create a database
#rows = db.execute <<-SQL
#  create table numbers (
#    name varchar(30),
#    val int
#  );
#SQL
#
## Execute a few inserts
#{
#  "one" => 1,
#  "two" => 2,
#}.each do |pair|
#  db.execute "insert into numbers values ( ?, ? )", pair
#end

# Find a few rows
db.execute( "select * from numbers" ) do |row|
  p row
end