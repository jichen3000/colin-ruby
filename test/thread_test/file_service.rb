# If we got this far, we are running as a service.
class Daemon
  def service_init
    # Give the service time to get everything initialized and running,
    # before we enter the service_main function.
    sleep 10
  end

  def service_main
    fileCount = 0 # Initialize the file counter for the rename
    watchForFile = "c:\\findme.txt"
    while state == RUNNING
      sleep 5
      if File.exists? watchForFile
          fileCount += 1
          File.rename watchForFile, watchForFile + "." + fileCount.to_s
      end
    end
  end
  d = Daemon.new
  d.mainloop
end
