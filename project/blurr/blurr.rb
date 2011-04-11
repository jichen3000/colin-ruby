
class BlurrArgv
  attr_accessor :start_run_day,
    :last_run_day, 
    :computer_name,
    :computer_argv_arr
end
class ComputerArgv
  attr_accessor :name,
    :music_tool_path,
    :browse_tool_path,
    :doc_tool_path,
    :skydoc_path_module,
    :diary_path_module,
    :diary_module_filepath,
    :language_argv_arr
#  @@e_traslate_path = 'D:\tools\PowerWord Lite\xdict.exe' 
#  @@j_traslate_path = 'D:\tools\Lingoes\Lingoes.exe' 
#  @@musicplay_path = 'D:\tools\foobar2000\foobar2000.exe' 
##      @@firefox_path = 'D:\tools\Mozilla Firefox\firefox.exe'
#  @@browser_path = 'C:\Users\Administrator\AppData\Local\Google\Chrome\Application\chrome.exe'
#  #@@office_path = 'D:\tools\OpenOffice.org 3\program\swriter.exe'
#  @@office_path = 'D:\tools\WPS Office Personal\office6\wps.exe'
#  @@diary_path_module = 'D:\back\我的资料\01MyDiary\双语日记%s.odt' 
#  @@diary_moduledoc_path = 'D:\back\我的资料\01MyDiary\module.odt' 
#  @@sky_path_module = 'D:\library\1日语学习\天声人語\天声人語%s.odt' 
#  @@sky_moduledoc_path = 'D:\library\1日语学习\天声人語\skymodule.odt' 
#  @@downtool_path = 'D:/tools/FlashGet/flashget.exe'
#  @@save_nhk_module = 'D:\library\1日语学习\NHK新闻听力\%s'
#  @@save_cnn_module = 'D:\library\2英语学习\CNN新闻听力\%s'
end
class LanguageArgv
  attr_accessor :name, 
    :news_save_path_module,
    :translate_tool_path  
end
module BlurrMethods
  
end
class Blurr
  require "date"
  require "yaml"
  include BlurrMethods
  def self.test_save_yml
    require 'iconv'
#    i = Iconv.open("utf-8", "GBK")
    i = Iconv.open("GBK", "utf-8")
    argv_arr = []
    ba = BlurrArgv.new
    ba.start_run_day = Date.parse("2008-06-02")
    ba.last_run_day = Date.parse("2010-03-02")
    ba.computer_name = 'notebook'
    ba.computer_argv_arr = []
    note_book = ComputerArgv.new
    note_book.name = 'notebook'
    note_book.music_tool_path = 'D:\tools\foobar2000\foobar2000.exe'
    note_book.language_argv_arr = []
    eng = LanguageArgv.new
    eng.name = 'eng'
    eng.news_save_path_module = 'D:\library\2english\cnn_news\%s'
#    eng.news_save_path_module = i.iconv('D:/library/2英语学习/CNN新闻听力/%s')
    note_book.language_argv_arr << eng
    jap = LanguageArgv.new
    jap.name = 'jap'
#    jap.news_save_path_module = 'D:\library\1日语学习\NHK新闻听力\%s'
#    jap.news_save_path_module = i.iconv('D:\library\1日语学习\NHK新闻听力\%s')
    note_book.language_argv_arr << jap
    
    ba.computer_argv_arr << note_book
    
    filename = File.join(File.dirname(__FILE__),'blurr.yml')
    file = File.new(filename,'w')
    YAML.dump(ba,file)
  end
  def self.test_load_yml
    filename = File.join(File.dirname(__FILE__),'blurr.yml')
    file = File.new(filename,'r')
    ba = YAML.load(file)
    p ba
  end
  def self.perform
    
  end
end

Blurr.test_load_yml
p "ok"