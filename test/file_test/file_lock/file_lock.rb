class FileLocker
  class << self
    def lock_file(fname,pid,program_name)
      begin
        File.symlink("#{pid}_#{program_name}_#{Time.now.strftime('%Y%m%d_%H%M%S')}",
          gen_lock_filename(fname))
        return true
      rescue Errno::EEXIST=>e
        return false
      end
    end
    
    def get_lock_info(fname)
      name = gen_lock_filename(fname)
      if File.symlink?(name)
        return File.readlink(name)
      else
        return "No such lock file(#{name})!"
      end
    end
    
    def unlock_file(fname,pid,program_name)
      name = gen_lock_filename(fname)
      if File.symlink?(name)
        if File.readlink(name).split('_').first.to_i==pid
          File.unlink(gen_lock_filename(fname))
          return true
        else
          puts "#{File.readlink(name)} has the key."
          return false
        end
      else
        puts "No such lock file(#{name})!"
        return false
      end
    end
    
    def check?(fname)
      File.symlink?(gen_lock_filename(fname))
    end
    
    def lock_file_will_wait(fname,pid,program_name,step_secs=1)
      while (not lock_file(fname,pid,program_name))
        sleep(step_secs)
      end
    end
    private
    def gen_lock_filename(fname)
      File.join(fname+".lock")
    end
  end
end

fname = 't.txt'
if FileLocker.lock_file(fname, Process.pid, 'fl')
  p "lock success"
else
  p "lock failed"
end
#puts FileLocker.get_lock_info(fname)
#FileLocker.lock_file_will_wait(fname, Process.pid, 'fl')
puts FileLocker.check?(fname)
puts FileLocker.get_lock_info(fname)
FileLocker.unlock_file(fname, 25836, 'fl')
#puts FileLocker.check?(fname)
#puts FileLocker.get_lock_info(fname)

p "ok"
