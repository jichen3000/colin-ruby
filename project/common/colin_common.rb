module ColinCommon
  def cal_seconds(hour,min)
    now = Time.now
    new_time = Time.local(
        now.year,now.month,now.day, hour, min)
    (new_time-now).to_i
  end
end