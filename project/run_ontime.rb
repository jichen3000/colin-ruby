class RunOntime
  def self.perform(programe, hour=21, min=0)
    sleep_seconds = cal_seconds(hour,min)
    puts "Programe(#{programe}) will run after seconds#{sleep_seconds}"
    sleep(sleep_seconds)
    system(programe)
  end
  def self.cal_seconds(hour,min)
    now = Time.now
    new_time = Time.local(
        now.year,now.month,now.day, hour, min)
    (new_time-now).to_i
  end
end

if ARGV.size > 0
  RunOntime.perform(ARGV[0],ARGV[1].to_i,ARGV[2].to_i)
else
  puts "error argv"
end

