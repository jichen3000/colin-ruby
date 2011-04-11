class SqlNotCauseError < StandardError
end
class SH
  def self.sql(hash)
    select_sql=''
    from_sql=''
    group_sql=''
    order_sql=''
    where_sql=''
    hash.each do |key,value|
      case key
      when :select; select_sql = "select #{get_value(value)} " if value
      when :from; from_sql = "from #{get_value(value)} "  if value
      when :group; group_sql = "group by #{get_value(value)} "  if value
      when :order; order_sql = "order by #{get_value(value)} "  if value
      when :order_desc; order_sql = "order by #{get_value(value)} desc "  if value
      when :where; where_sql = "where #{get_value(value,' and ')} "  if value
      end
    end
    if select_sql.strip.empty?
      raise SqlNotCauseError.new("you must have \#select")
    end
    if from_sql.strip.empty?
      raise SqlNotCauseError.new("you must have \#from")
    end
    sql = select_sql+from_sql+where_sql+group_sql+order_sql
  end
  # 
  def self.gen_type_case(step,type)
    arr = nil
    case type
      when 'ss';arr = get_when_arr_0(step,60,'ss','yyyymmddhh24mi')
      when 'mi';arr = get_when_arr_0(step,60,'mi','yyyymmddhh24')
      when 'hh24';arr = get_when_arr_0(step,24,'hh24','yyyymmdd')
      when 'dd';arr = get_when_arr_1(step,30,'dd','yyyymm')
      when 'mm';arr = get_when_arr_1(step,12,'mm','yyyy')
    end
    "case "+arr.join(" ")+" end "
  end
  private
  def self.get_value(value,join_str=',')
    if value.is_a?(Array)
      value.join(join_str)
    else
      value
    end
  end
  def self.get_when_arr_0(step,count,type,time_format)
    iterations = (count/step).to_i
    arr = []
    iterations.times do |index|
      start=index*step
      if step != 1
        arr << "when to_char(observation_time,'#{type}') between #{start} and #{start+step-1} "+
            "then to_char(observation_time,'#{time_format}')||'#{start.to_s.rjust(2,'0')}'"
      else
        arr << "when to_char(observation_time,'#{type}')=#{start} "+
            "then to_char(observation_time,'#{time_format}')||'#{start.to_s.rjust(2,'0')}'"
      end
    end
    arr
  end
  def self.get_when_arr_1(step,count,type,time_format)
    iterations = (count/step).to_i
    arr = []
    iterations.times do |index|
      start=index*step+1
      if step != 1
        arr << "when to_char(observation_time,'#{type}') between #{start} and #{start+step-1} "+
            "then to_char(observation_time,'#{time_format}')||'#{start.to_s.rjust(2,'0')}'"
      else
        arr << "when to_char(observation_time,'#{type}')=#{start} "+
            "then to_char(observation_time,'#{time_format}')||'#{start.to_s.rjust(2,'0')}'"
      end
    end
    arr
  end
end

require "test/unit"
class SHTest < Test::Unit::TestCase
  def setup
  end
  def test_case
    assert_equal("case "+
      "when to_char(observation_time,'ss') between 0 and 29 "+
      "then to_char(observation_time,'yyyymmddhh24mi')||'00' "+
      "when to_char(observation_time,'ss') between 30 and 59 "+
      "then to_char(observation_time,'yyyymmddhh24mi')||'30' "+
      "end ",
      SH.gen_type_case(30,'ss'))
    assert_equal("case "+
      "when to_char(observation_time,'mi') between 0 and 29 "+
      "then to_char(observation_time,'yyyymmddhh24')||'00' "+
      "when to_char(observation_time,'mi') between 30 and 59 "+
      "then to_char(observation_time,'yyyymmddhh24')||'30' "+
      "end ",
      SH.gen_type_case(30,'mi'))
    assert_equal("case "+
      "when to_char(observation_time,'hh24') between 0 and 11 "+
      "then to_char(observation_time,'yyyymmdd')||'00' "+
      "when to_char(observation_time,'hh24') between 12 and 23 "+
      "then to_char(observation_time,'yyyymmdd')||'12' "+
      "end ",
      SH.gen_type_case(12,'hh24'))
    assert_equal("case "+
      "when to_char(observation_time,'dd') between 1 and 15 "+
      "then to_char(observation_time,'yyyymm')||'01' "+
      "when to_char(observation_time,'dd') between 16 and 30 "+
      "then to_char(observation_time,'yyyymm')||'16' "+
#      "when to_char(observation_time,'dd') between 31 and 45 "+
#      "then to_char(observation_time,'yyyymm')||'31' "+
      "end ",
      SH.gen_type_case(15,'dd'))
    assert_equal("case "+
      "when to_char(observation_time,'mm')=1 "+
      "then to_char(observation_time,'yyyy')||'01' "+
      "when to_char(observation_time,'mm')=2 "+
      "then to_char(observation_time,'yyyy')||'02' "+
      "when to_char(observation_time,'mm')=3 "+
      "then to_char(observation_time,'yyyy')||'03' "+
      "when to_char(observation_time,'mm')=4 "+
      "then to_char(observation_time,'yyyy')||'04' "+
      "when to_char(observation_time,'mm')=5 "+
      "then to_char(observation_time,'yyyy')||'05' "+
      "when to_char(observation_time,'mm')=6 "+
      "then to_char(observation_time,'yyyy')||'06' "+
      "when to_char(observation_time,'mm')=7 "+
      "then to_char(observation_time,'yyyy')||'07' "+
      "when to_char(observation_time,'mm')=8 "+
      "then to_char(observation_time,'yyyy')||'08' "+
      "when to_char(observation_time,'mm')=9 "+
      "then to_char(observation_time,'yyyy')||'09' "+
      "when to_char(observation_time,'mm')=10 "+
      "then to_char(observation_time,'yyyy')||'10' "+
      "when to_char(observation_time,'mm')=11 "+
      "then to_char(observation_time,'yyyy')||'11' "+
      "when to_char(observation_time,'mm')=12 "+
      "then to_char(observation_time,'yyyy')||'12' "+
      "end ",
      SH.gen_type_case(1,'mm'))
#    assert_equal("case "+
#      "when to_char(observation_time,'mi') = 0 "+
#      "then to_char(observation_time,'yyyymmddhh24')||'00' "+
#      "end ",
#      SH.gen_type_case(1,'mi'))
  end
  def test_sql_just_select
    hash={:select=>"A a, B a"}
    assert_raise(SqlNotCauseError) do
      SH.sql(hash)
    end
  end
  def test_sql_nil
    hash={:select=>"A a, B a",:from=>"cc",:group=>nil}
    assert_equal("select A a, B a from cc ",SH.sql(hash))
  end
  
  def test_sql_select_from
    hash={:select=>"A a, B a",:from=>"cc"}
    assert_equal("select A a, B a from cc ",SH.sql(hash))
    hash={:select=>["A a","B a"],:from=>"cc"}
    assert_equal("select A a,B a from cc ",SH.sql(hash))
    hash={:select=>["A a","B a"],:from=>["cc","dd"]}
    assert_equal("select A a,B a from cc,dd ",SH.sql(hash))
  end
  def test_sql_where
    hash={:select=>"A a, B a",:from=>"cc",:where=>"1=2"}
    assert_equal("select A a, B a from cc where 1=2 ",SH.sql(hash))
    hash={:select=>"A a, B a",:from=>"cc",:where=>["1=2"]}
    assert_equal("select A a, B a from cc where 1=2 ",SH.sql(hash))
    hash={:select=>"A a, B a",:from=>"cc",:where=>["1=2","2=3"]}
    assert_equal("select A a, B a from cc where 1=2 and 2=3 ",SH.sql(hash))
    hash={:select=>"A a, B a",:from=>"cc",:where=>["1=2 or 2=3"]}
    assert_equal("select A a, B a from cc where 1=2 or 2=3 ",SH.sql(hash))
  end
  def test_sql_order
    hash={:select=>"A a, B a",:from=>"cc",:order=>"a"}
    assert_equal("select A a, B a from cc order by a ",SH.sql(hash))
    hash={:select=>"A a, B a",:from=>"cc",:order_desc=>"a"}
    assert_equal("select A a, B a from cc order by a desc ",SH.sql(hash))
  end
  def test_sql_group
    hash={:select=>"A a, B a",:from=>"cc",:group=>"a"}
    assert_equal("select A a, B a from cc group by a ",SH.sql(hash))
  end
end