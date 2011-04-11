############################################################################
# Options:
#    install    - Installs the service.  The service name is "DemoSvc"
#                 and the display name is "Demo".
#    start      - Starts the service.  Make sure you stop it at some point or
#                 you will eventually fill up your filesystem!.
#    stop       - Stops the service.
#    pause      - Pauses the service.
#    resume     - Resumes the service.
#    uninstall  - Uninstalls the service.
#    delete     - Same as uninstall.
#
# You can also used the Windows Services GUI to start and stop the service.
#
# To get to the Windows Services GUI just follow:
#    Start -> Control Panel -> Administrative Tools -> Services
############################################################################
require 'win32/service'
include Win32
class ServiceLogger
  def info(msg)
    puts msg
  end
end
#require 'logger'
#class ServiceLogger < Logger
#    def initialize(logdev, shift_age = 0, shift_size = 1048576, is_print=false)
#      @is_print = is_print
#      super(logdev, shift_age, shift_size)
#      self.datetime_format = '%m-%d %H:%M:%S' 
#      
#    end
#    def info(msg,&block)
#      puts msg if @is_print
#      super
#    end
#    def debug(msg,&block)
#      puts msg if @is_print
#      super
#    end
#    def error(msg,&block)
#      puts msg if @is_print
#      super
#    end
#    def fatal(msg,&block)
#      puts msg if @is_print
#      super
#    end
#    def warn(msg,&block)
#      puts msg if @is_print
#      super
#    end
#end
# Make sure you're using the version you think you're using.
#puts 'VERSION: ' + Service::VERSION

class Win32FileService
    SERVICE_NAME = 'FilebackupSvc'
    SERVICE_DISPLAYNAME = 'FilebackupSvc'
    RB_FILENAME = 'win32_filebackup.rb'
#    RUBY_DIR='D:\WORK_HOME\InstantRails\ruby\bin\ruby.exe '+RB_FILENAME
    RUBY_DIR='ruby '+RB_FILENAME
    def perform(cmd) 
        # Quote the full path to deal with possible spaces in the path name.
        #ruby = File.join(BIN_DIR, 'ruby').tr('/', '\\')
        #path = ' "' + File.dirname(File.expand_path($0)).tr('/', '\\')
        #path += '\#{RB_FILENAME}"'
        #cmd = ruby + path
#        @log = get_log("\FilebackupSvc.log",  2, 1048576, true)
        @log = ServiceLogger.new
        run(cmd)
    end
    def get_log(logdev, shift_age = 0, shift_size = 1048576, is_print=false)
        ServiceLogger.new(logdev,shift_age,shift_size,is_print)
    end
    def run(cmd)
      case cmd.downcase
         when 'install'
           @log.info "install start..."
           puts __FILE__
            Service.new(
               :service_name     => SERVICE_NAME,
               :service_type     => Service::WIN32_OWN_PROCESS,
               :display_name     => SERVICE_DISPLAYNAME,
               :description      => 'filebackup service',
               :binary_path_name => RUBY_DIR
            )
             @log.info 'Service ' + SERVICE_NAME + ' installed'      
         when 'start'
            if Service.status(SERVICE_NAME).current_state != 'running'
               Service.start(SERVICE_NAME, nil, 'hello', 'world')
               while Service.status(SERVICE_NAME).current_state != 'running'
                  @log.info 'One moment...' + Service.status(SERVICE_NAME).current_state
                  sleep 1
               end
               @log.info 'Service ' + SERVICE_NAME + ' started'
            else
               @log.info 'Already running'
            end
         when 'stop'
            if Service.status(SERVICE_NAME).current_state != 'stopped'
               Service.stop(SERVICE_NAME)
               while Service.status(SERVICE_NAME).current_state != 'stopped'
                  @log.info 'One moment...' + Service.status(SERVICE_NAME).current_state
                  sleep 1
               end
               @log.info 'Service ' + SERVICE_NAME + ' stopped'
            else
               @log.info 'Already stopped'
            end
         when 'uninstall', 'delete'
            if Service.status(SERVICE_NAME).current_state != 'stopped'
               Service.stop(SERVICE_NAME)
            end
            while Service.status(SERVICE_NAME).current_state != 'stopped'
               @log.info 'One moment...' + Service.status(SERVICE_NAME).current_state
               sleep 1
            end
            Service.delete(SERVICE_NAME)
            @log.info 'Service ' + SERVICE_NAME + ' deleted'
         when 'pause'
            if Service.status(SERVICE_NAME).current_state != 'paused'
               Service.pause(SERVICE_NAME)
               while Service.status(SERVICE_NAME).current_state != 'paused'
                  @log.info 'One moment...' + Service.status(SERVICE_NAME).current_state
                  sleep 1
               end
               @log.info 'Service ' + SERVICE_NAME + ' paused'
            else
               @log.info 'Already paused'
            end
         when 'resume'
            if Service.status(SERVICE_NAME).current_state != 'running'
               Service.resume(SERVICE_NAME)
               while Service.status(SERVICE_NAME).current_state != 'running'
                  @log.info 'One moment...' + Service.status(SERVICE_NAME).current_state
                  sleep 1
               end
               @log.info 'Service ' + SERVICE_NAME + ' resumed'
            else
               @log.info 'Already running'
            end
         else
            raise ArgumentError, 'unknown option: ' + cmd
      end
    end
end
Win32FileService.new.perform("install")