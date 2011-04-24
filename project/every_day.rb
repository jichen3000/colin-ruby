require "date"
require 'timeout'
require 'fileutils'

class EveryDay
  @@start_day = Date.parse("2008-06-02")
  class << self
    def perform(type)
      my = EveryDay.new(type)
      my.perform
    end
    def perform_test(type)
      my = EveryDay.new(type)
#      my.download_cnn_news
      my
    end
  end
  def initialize(type)
    @log = File.open("erveryday.log","w+")
    @today = Date.today
    @yesterday = @today - 1
    
    set_type(type)
    # test
#    @today = Date.parse("2008-06-12")
  end
  HOME_TYPE = 'HOME'
  OFFICE_TYPE = 'OFFICE'
  def set_type(type)
    @type = type
    if @type == HOME_TYPE
      @@e_traslate_path = 'D:\tools\PowerWord Lite\xdict.exe' 
      @@j_traslate_path = 'D:\tools\Lingoes\Lingoes.exe' 
      @@foobar_path = 'D:\tools\foobar2000\foobar2000.exe' 
#      @@firefox_path = 'D:\tools\Mozilla Firefox\firefox.exe'
      @@firefox_path = 'C:\Users\colin\AppData\Local\Google\Chrome\Application\chrome.exe'
      #@@office_path = 'D:\tools\OpenOffice.org 3\program\swriter.exe'
      @@office_path = 'D:\tools\WPS Office Personal\office6\wps.exe'
      @@diary_path_module = 'D:\back\我的资料\01MyDiary\双语日记%s.odt' 
      @@diary_moduledoc_path = 'D:\back\我的资料\01MyDiary\module.odt' 
      @@sky_path_module = 'D:\library\1日语学习\天声人語\天声人語%s.odt' 
      @@sky_moduledoc_path = 'D:\library\1日语学习\天声人語\skymodule.odt' 
      @@flashget_path = 'D:/tools/FlashGet/flashget.exe'
      @@save_nhk_module = 'D:\library\1日语学习\NHK新闻听力\%s'
      @@save_cnn_module = 'D:\library\2英语学习\CNN新闻听力\%s'
    elsif @type == OFFICE_TYPE
      @@e_traslate_path = 'D:\tools\PowerWord Lite\xdict.exe' 
      @@j_traslate_path = 'D:\tools\Lingoes\Lingoes.exe' 
      @@foobar_path = 'D:\tools\foobar2000\foobar2000.exe' 
      @@firefox_path = 'D:\tools\Mozilla Firefox\firefox.exe'
      @@office_path = 'D:\tools\OpenOffice.org 3\program\swriter.exe'
#      @@diary_path_module = 'D:\back\我的资料\01MyDiary\双语日记%s.odt' 
#      @@diary_moduledoc_path = 'D:\back\我的资料\01MyDiary\module.odt' 
#      @@sky_path_module = 'D:\library\1日语学习\天声人語\天声人語%s.odt' 
#      @@sky_moduledoc_path = 'D:\library\1日语学习\天声人語\skymodule.odt' 
      @@flashget_path = 'D:\tools\FlashGet\FlashGet.exe'
#      @@flashget_path = 'D:\tools\FlashGet Mini\FlashGetMini.exe'
#      alias download_by_flashget download_by_flashgetmini 
      @@save_nhk_module = 'D:\down\study'
      @@save_cnn_module = 'D:\down\study'
    end
    @@nhk_module = "mms://wm.nhk.or.jp/r-news/%s070003_2_1_morning.wma"
    @@cnn_news_module = 'http://podcasts.cnn.net/cnn/services/podcasting/newscast/audio/%s/CNN-News-%s-5PM.mp3'
    @@cnn_biz_module = 'http://podcasts.cnn.net/cnn/services/podcasting/marketplace/audio/%s/CNN-Biz-%s-5PM.mp3'
  end
  def perform
    add_log "App start.."
    add_log(colin_str_time(Time.now))
    # 需要先打开firefox，否则会发生打个很多个,每一个只有一个tab。
    # 这种情况只有在比较慢的机器上会发生。
    add_log "open_firefox start.."
    open_firefox
    add_log "open_firefox end."
    if is_odd(@today, @@start_day)
      add_log "download_cnn_news start.."
      download_cnn_news
      add_log "download_cnn_news end."
      
#      add_log "open_firefox_e start.."
#      open_firefox_e
#      add_log "open_firefox_e end."
      
    else
      add_log "download_nhk_news start.."
      download_nhk_news
      add_log "download_nhk_news end."
      
#      add_log "open_firefox_j start.."
#      open_firefox_j
#      add_log "open_firefox_j end."
      
    end
    
    
    
    add_log "open_j_traslate start.."
    open_j_traslate
    add_log "open_j_traslate end."
    
    add_log "open_dir start.."
    open_dir
    add_log "open_dir end."
    
    add_log "open_foobar start.."
    open_foobar
    add_log "open_foobar end."
    
    if is_odd(@today, @@start_day)
      add_log "open_firefox_e start.."
      open_firefox_e
      add_log "open_firefox_e end."
    else
      add_log "open_firefox_j start.."
      open_firefox_j
      add_log "open_firefox_j end."
    end
    if @type == HOME_TYPE
      if is_last_first_mday(@today)
        add_log "open_diary start.."
        open_diary
        add_log "open_diary end."
      end
      
      if (@today.cwday == 6) || is_last_first_mday(@today)
        add_log "open_skydoc start.."
        #open_skydoc
        open_saturday
        add_log "open_skydoc end."
      end
    end  
      
    add_log "App End!"
    p __FILE__
    exit
  end
  def my_system(call_str)
    add_log call_str
    begin
      Timeout.timeout(5) {system(call_str)}
    rescue Timeout::Error
    end
  end
#  @@e_traslate_path = 'D:\tools\PowerWord Lite\xdict.exe' 
  def open_e_traslate
    my_system(@@e_traslate_path)
  end       
#  @@j_traslate_path = 'D:\tools\Lingoes\Lingoes.exe' 
  def open_j_traslate
    my_system(@@j_traslate_path)
  end       
#  @@foobar_path = 'D:\tools\foobar2000\foobar2000.exe' 
  def open_foobar
    my_system(@@foobar_path)
  end       
#  @@firefox_path = 'D:\tools\Mozilla Firefox\firefox.exe'
  def open_firefox(url=nil)
    if url
      url.each do |url|
        my_system(@@firefox_path + " -new-tab " + url)
      end
    else
      my_system(@@firefox_path)
    end    
  end
  def open_firefox_j
    url = ['http://dictionary.www.infoseek.co.jp/',
      'http://www.yomiuri.co.jp/',
      'http://www3.nhk.or.jp/toppage/navi/news.html',
      'http://www.asahi.com/paper/column.html',
      'https://docs.google.com/document/d/1UpdWZSxz5RC3MQZM6hUUo6G7zBN9XTXTQKsHP1uOGpU/edit?hl=zh_CN']
    open_firefox(url)
  end
  def open_firefox_e
    url = ['http://edition.cnn.com/',
      'http://www.asahi.com/paper/column.html',
      'https://docs.google.com/document/d/1UpdWZSxz5RC3MQZM6hUUo6G7zBN9XTXTQKsHP1uOGpU/edit?hl=zh_CN']
    open_firefox(url)
  end
#  @@office_path = 'C:\Program Files\OpenOffice.org 2.2\program\swriter.exe'
#  @@office_path = 'D:\tools\OpenOffice.org 3\program\swriter.exe'
  def open_doc(filename=nil)
    if filename
      call_str = @@office_path + " " + filename   
    else
      call_str = @@office_path
    end
    my_system(call_str) 
  end
#  @@diary_path_module = 'D:\back\我的资料\01MyDiary\双语日记%s.odt' 
#  @@diary_moduledoc_path = 'D:\back\我的资料\01MyDiary\module.odt' 
  def open_diary
    diary_path = @@diary_path_module % @today.strftime('%Y%m')
    if not File.exist?(diary_path)
      FileUtils.copy(@@diary_moduledoc_path,diary_path)           
    end
    open_doc(diary_path)
  end
  def open_saturday
    url = [
      'http://docs.google.com/Doc?id=dfdwr927_179fzqtsvc5']
    open_firefox(url)
  end
#  @@sky_path_module = 'D:\library\1日语学习\天声人語\天声人語%s.odt' 
#  @@sky_moduledoc_path = 'D:\library\1日语学习\天声人語\skymodule.odt' 
  def open_skydoc
    sky_path = @@sky_path_module % @today.strftime('%Y%m')
    if not File.exist?(sky_path)
      FileUtils.copy(@@sky_moduledoc_path,sky_path)           
    end
    open_doc(sky_path)
  end
  def open_dir
    call_str = "explorer.exe #{@today_save_dir}"
    add_log call_str
    system(call_str)   
  end
#  def check_day
#    (@today - @@start_day) % 2
#  end
  def is_odd(date,start_date)
    ((date - start_date).to_i % 2) == 1
  end
  def is_last_first_mday(date)
    date.mday == 1 || date.next.mday == 1 
  end
  def colin_str_time(time)
    result = time.strftime('%Y-%m-%d %H:%M:%S')
    if time.respond_to?(:usec)
      result += ' '+time.usec.to_s
    end
    result
  end
  def download_by_flashget(addr,save_dir)
    if not File.directory?(save_dir)
      Dir.mkdir(save_dir)
    end
    my_system("#{@@flashget_path} #{addr} #{save_dir}")
  end
  def download_by_flashgetmini(addr,save_dir)
    if not File.directory?(save_dir)
      Dir.mkdir(save_dir)
    end
    my_system("#{@@flashget_path} -addlink (#{addr}) TEXT(study) REF() ")
  end
  def download_nhk_news
    nhk_addr = @@nhk_module % @today.strftime('%Y%m%d')
    @today_save_dir = @@save_nhk_module % @today.strftime('%Y%m')
    download_by_flashget(nhk_addr,@today_save_dir)
  end
#  @@save_cnn_module = 'D:\library\2英语学习\CNN新闻听力\%s'
#  @@cnn_news_module = 'http://podcasts.cnn.net/cnn/services/podcasting/newscast/audio/%s/CNN-News-%s-5PM.mp3'
#  @@cnn_biz_module = 'http://podcasts.cnn.net/cnn/services/podcasting/marketplace/audio/%s/CNN-Biz-%s-5PM.mp3'
  def download_cnn_news
    cnn_news_addr = @@cnn_news_module % [ @yesterday.strftime('%Y/%m/%d'),
      @yesterday.strftime('%m-%d-%y')]
    cnn_biz_addr = @@cnn_biz_module % [ @yesterday.strftime('%Y/%m/%d'),
      @yesterday.strftime('%m-%d-%y')]
        @today_save_dir = @@save_cnn_module % @today.strftime('%Y%m')
        download_by_flashget(cnn_news_addr,@today_save_dir)
#        sleep 2
#        download_by_flashget(cnn_biz_addr,@today_save_dir)
  end
  def add_log(msg)
    time = Time.now
    new_msg = time.strftime('%Y-%m-%d %H:%M:%S ')+' '+time.usec.div(1000).to_s.rjust(3,"0") +
      " : "+msg
    puts new_msg
    @log << new_msg + "\n"
  end
end
if ARGV.size > 0
  type = ARGV[0].upcase if ARGV.size>0
  
  type ||= EveryDay::OFFICE_TYPE 
  EveryDay.perform(type)
end
#EveryDay.perform_test(type)
