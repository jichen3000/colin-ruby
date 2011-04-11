class ShutdownOntime
  def self.perform(hour=21, min=0)
    now = Time.now
    shutdown_time = Time.local(
        now.year,now.month,now.day, hour, min)
    seconds = (shutdown_time-now).to_i
    system("shutdown -s -f -t #{seconds}")
  end
end

if ARGV.size > 0
  ShutdownOntime.perform(ARGV[0].to_i,ARGV[1].to_i)
else
  puts "error argv"
end
