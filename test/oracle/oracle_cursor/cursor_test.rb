# 问题，在copylog程序中会遇到oracle的open_cursor最大的错误。

require 'activerecord'

ActiveRecord::Base.establish_connection(
  :adapter => 'oracle_enhanced',
  :database => 'drb',
  :host => 'drb',
  :username => 'mcdbra',
  :password => 'mcdbra'
)

class Session < ActiveRecord::Base
  set_inheritance_column(:jc)
  self.table_name='v$session'
  def self.find_me
    find(:all, :conditions=>"AUDSID=(select sys_context('USERENV','SESSIONID') FROM DUAL)")
  end
  def mytype=(ntmp)
    write_attribute("type",ntmp)
  end
  def mytype
    return read_attribute("type")
  end
end

class OpenCursor < ActiveRecord::Base
  self.table_name = 'v$open_cursor'
  def self.my_cursors(sid)
    find(:all, :conditions=>"sid=#{sid}")
  end
  def self.find_my_cursors
    sessions = Session.find_me
    if sessions.size > 1
      raise "session error"
    end
    my_cursors(sessions[0].sid)
  end
  def to_s
    sid.to_i.to_s+"\t"+user_name+"\t"+sql_id+"\n"+sql_text
  end
  def self.print_list(arr)
    puts "cursor count: #{arr.size}"
    arr.each do |item|
      puts item
    end
  end
end

class Other < ActiveRecord::Base
  self.table_name = "mc$dr_ors"
end

class NoTable < ActiveRecord::Base
  def self.exec_sql(sql)
    cursor = self.connection.execute(sql)
    cursor.close
  end
end

# 有时会相差一个cursor，有时一个也不差
def test1
  start_cursors = OpenCursor.find_my_cursors
  puts "start cursors count: #{start_cursors.size}"
  other = Other.find(:all)
  end_cursors = OpenCursor.find_my_cursors
  puts "end cursors count: #{end_cursors.size}"
  puts "real cursors: #{end_cursors.size-start_cursors.size}"
end
# 这样的结果基本和test1是一样的。
def test2
  start_cursors = OpenCursor.find_my_cursors
  puts "start cursors count: #{start_cursors.size}"
  runs = 1000
  runs.times do |i|
    other = Other.find(:all)
    if (i<20)or (i%20==0)
      cursors = OpenCursor.find_my_cursors
      puts "#{i} cursors count: #{cursors.size}"      
    end
  end
  end_cursors = OpenCursor.find_my_cursors
  puts "end cursors count: #{end_cursors.size}"
  puts "real cursors: #{end_cursors.size-start_cursors.size}"
end
# 执行简单查询，但不关闭cursor，可以看到cursor在300以内的循环不停的增长，
# 但在300以后也不会增长，反而会下降
def test3
  start_cursors = OpenCursor.find_my_cursors
  puts "start cursors count: #{start_cursors.size}"
  runs = 1000
  runs.times do |i|
    other1 = ActiveRecord::Base.connection.execute("select * from tab")
    if (i<20)or (i%20==0)
      cursors = OpenCursor.find_my_cursors
      puts "#{i} cursors count: #{cursors.size}"      
    end
  end
  end_cursors = OpenCursor.find_my_cursors
  puts "end cursors count: #{end_cursors.size}"
  puts "real cursors: #{end_cursors.size-start_cursors.size}"
end
# 关闭了就不会有增长了。
def test4
  start_cursors = OpenCursor.find_my_cursors
  puts "start cursors count: #{start_cursors.size}"
  runs = 1000
  runs.times do |i|
    other1 = ActiveRecord::Base.connection.execute("select * from tab")
    other1.close
    if (i<20)or (i%20==0)
      cursors = OpenCursor.find_my_cursors
      puts "#{i} cursors count: #{cursors.size}"      
    end
  end
  end_cursors = OpenCursor.find_my_cursors
  puts "end cursors count: #{end_cursors.size}"
  puts "real cursors: #{end_cursors.size-start_cursors.size}"
end
# 一个查询和两个并不会有太大的差别
def test5
  start_cursors = OpenCursor.find_my_cursors
  puts "start cursors count: #{start_cursors.size}"
  runs = 1000
  runs.times do |i|
    other = Other.find(:all)
    other1 = Other.find(:all)
    if (i<20)or (i%20==0)
      cursors = OpenCursor.find_my_cursors
      puts "#{i} cursors count: #{cursors.size}"      
    end
  end
  end_cursors = OpenCursor.find_my_cursors
  puts "end cursors count: #{end_cursors.size}"
  puts "real cursors: #{end_cursors.size-start_cursors.size}"
end
# 条件不一样不会影响结果。
def test6
  start_cursors = OpenCursor.find_my_cursors
  puts "start cursors count: #{start_cursors.size}"
  runs = 1000
  runs.times do |i|
    other = Other.find(:all)
    other1 = Other.find(:all,:conditions=>'id>3')
    if (i<20)or (i%20==0)
      cursors = OpenCursor.find_my_cursors
      puts "#{i} cursors count: #{cursors.size}"      
    end
  end
  end_cursors = OpenCursor.find_my_cursors
  puts "end cursors count: #{end_cursors.size}"
  puts "real cursors: #{end_cursors.size-start_cursors.size}"
end
# find_by_sql和普通的find是一样的，也会自动关闭cursor
def test7
  start_cursors = OpenCursor.find_my_cursors
  puts "start cursors count: #{start_cursors.size}"
  runs = 1000
  runs.times do |i|
    other = Other.find(:all)
    other1 = Other.find_by_sql("select * from #{Other.table_name} where id > 3")
    if (i<20)or (i%20==0)
      cursors = OpenCursor.find_my_cursors
      puts "#{i} cursors count: #{cursors.size}"      
    end
  end
  end_cursors = OpenCursor.find_my_cursors
  puts "end cursors count: #{end_cursors.size}"
  puts "real cursors: #{end_cursors.size-start_cursors.size}"
end
# 复杂的sql也一样。
def test8
  start_cursors = OpenCursor.find_my_cursors
  puts "start cursors count: #{start_cursors.size}"
  runs = 1000
  runs.times do |i|
    other = Other.find(:all)
    other1 = Other.find_by_sql("select * from #{Other.table_name} where id >"+
      "(select id from jc_test where id = 1)")
    if (i<20)or (i%20==0)
      cursors = OpenCursor.find_my_cursors
      puts "#{i} cursors count: #{cursors.size}"      
    end
  end
  end_cursors = OpenCursor.find_my_cursors
  puts "end cursors count: #{end_cursors.size}"
  puts "real cursors: #{end_cursors.size-start_cursors.size}"
end

test8
p "ok"
