require "date"
require 'timeout'
require 'fileutils'

class ColinLogger
  def initialize(filename)
    @log_file = File.open(filename,"w+")
  end
  def get_now_time_str
    time = Time.now
    return time.strftime('%Y-%m-%d %H:%M:%S ')+' '+time.usec.div(1000).to_s.rjust(3,"0") 
  end
  def info(msg)
    full_msg = get_now_time_str + " [info ]: "+msg
    puts full_msg
    @log_file << full_msg + "\n"
  end
  def error(msg)
    full_msg = get_now_time_str + " [error]: "+msg
    @log_file << full_msg + "\n"
  end
end
$logger = ColinLogger.new("morning_study.log")

class MorningStudy
  def self.perform(location)
    morning_study = MorningStudy.get_instance(location)
    $logger.info("app start ")
    
    morning_study.perform()
    
    $logger.info("app end ")
  end
  HOME_PC = 'HOME'
  OFFICE_PC = 'OFFICE'
  def get_instance(pc)
    if pc == HOME_PC
      return MorningStudyAtHome.new
    elsif pc == OFFICE_PC
      return MorningStudyAtOffice.new
    else
      raise "not support pc:#{pc}"
    end
  end  
end

module StudyOperations
  def initialize
    @log = ColinLogger.new("erveryday.log")
    @today = Date.today
    @yesterday = @today - 1    
  end
  
  def perform()
    start_day = Date.parse("2008-06-02")
    if(is_odd_day(start_day))
      perform_odd_day
    else
      perform_even_day
    end
    perform_special
  end
  
  private
  def perform_odd_day()
    open_firefox
    
    download_cnn_news
    
    open_j_traslate
    
    open_dir
    
    open_foobar
    
    open_firefox_e    
  end
  
  def perform_even_day()
    open_firefox
    download_nhk_news
    open_j_traslate
    open_dir
    open_foobar
    open_japanese_grammar_doc
    open_firefox_j
  end
  
  def open_firefox(firefox_path, url=nil)
    if url
      url.each do |url|
        my_system(firefox_path + " -new-tab " + url)
      end
    else
      my_system(firefox_path)
    end    
  end  
end

class MorningStudyAtHome
  include StudyOperations
  
  
  
  def perform_specail
    if is_last_first_mday(@today)
      open_diary
    end      
  end
end

if ARGV.size > 0
  type = ARGV[0].upcase if ARGV.size>0
  
  type ||= EveryDay::OFFICE_TYPE 
  EveryDay.perform(type)
end
