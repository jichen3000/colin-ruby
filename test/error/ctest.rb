ENV["MEGATRUST_DAEMON_HOME"] = '/megatrust/megatrust_web/daemon/'
require File.join(ENV["MEGATRUST_DAEMON_HOME"],"config/enviroment")
require 'lib/common/send_message'
require 'lib/common/time_count'
require 'lib/common/others'
require 'lib/common/errors'

require 'bgconfig'
require 'platform_warn_config'
require "warn_sub_config"
require "warn_config"
require 'issue'
require "perform_issue"
require 'host'
require 'database'
require 'perform_issue_his'
require 'issue_mail'
require 'mail_his'
require 'action_desc'
require 'error_log'
require 'script_result'

# 自定义方法
module GroupMethods
  #自定义方法（平均值）
  def avg_method(col_index)
    hash = get_hash
    sum = 0
    col_index = col_index - 1
    hash.each do |key,value|
      sum += change_to_number(value[col_index])
    end
    sum/hash.keys.size
  end
  
  #自定义方法（最大值）
  def max_method(col_index)
    hash = get_hash
    col_index = col_index - 1
    max = hash.values.first[col_index].to_f
    hash.each do |key, value|
      cur = change_to_number(value[col_index])
      if (cur > max)
        max = cur
      end
    end
    max
  end
  #自定义方法（最小值）
  def min_method(col_index)
    hash = get_hash
    col_index = col_index - 1
    min = hash.values.first[col_index].to_f
    hash.each do |key, value|
      cur = change_to_number(value[col_index])
      if cur <= min
        min=cur
      end
    end
    min
  end
  
  #自定义方法（和值）  
  def sum_method(col_index)
    hash = get_hash
    sum = 0
    col_index = col_index - 1
    hash.each do |key, value|
      sum += change_to_number(value[col_index])
    end
    sum
  end
  
  FLOAT_PATTARN = /\d+/
  def change_to_number(number_str)
    if ((number_str=~FLOAT_PATTARN)==0)
      return number_str.to_f
    else
      raise ChangeNumberError.new("can't change to number.(str:#{number_str})")
    end
  end
  
  def get_number(col_index)
    data = get_data
    col_index = col_index - 1
    change_to_number(data[col_index])
  end
    
  def get_string(col_index)
    data = get_data
    col_index = col_index - 1
    return data[col_index]
  end

end


class CaptureWarning
  attr_accessor :file, :last_change_time, :platform_warn_config, 
    :warn_config_arr, :store_columns
  include GroupMethods

  def init_wait_step(step_wait_seconds,total_wait_seconds)
    @step_wait_seconds = step_wait_seconds
    @total_wait_seconds = total_wait_seconds
  end
  
  def init_warn_config_arr(platform_warn_config)
    @warn_config_arr = WarnConfig.find(:all,
       :conditions=>["script_type=? and status=? and host_type like ? and ( "+
         "exclude_target is null or instr(exclude_target,'#{platform_warn_config.target_id}') = ? )",
         'COMMAND','ENABLED',"%#{platform_warn_config.target.os_name}%",0])
    check_warn_config_arr(@warn_config_arr)
  end
  
  def check_warn_config_arr(warn_config_arr)
    warn_config_arr.delete_if{|x| (not check_warn_config(x))}
  end
  
  def check_warn_config(warn_config)
    warn_sub_config_arr = warn_config.warn_sub_configs
    if warn_sub_config_arr == []
      return false
    else
      warn_sub_config_arr.delete_if{|x| (not check_warn_sub_config(x))}
    end
    if warn_sub_config_arr.size == 0
      return false
    end
    return true
  end
  
  def check_warn_sub_config(warn_sub_config) 
    if warn_sub_config.error_code == nil 
      ErrorLog.capture_error_for_user(@platform_warn_config.target,warn_sub_config,
                  ErrorLog::PROGRAME_CAPTURE_WARNING,
                  "error_code is nil",
                  "错误代码没有定义")
      return false
    end
    if warn_sub_config.name == nil
      ErrorLog.capture_error_for_user(@platform_warn_config.target,warn_sub_config,
                  ErrorLog::PROGRAME_CAPTURE_WARNING,
                  "name is nil",
                  "子配置项名没有定义")
      return false
    end
    if warn_sub_config.compare_type == nil
      ErrorLog.capture_error_for_user(@platform_warn_config.target,warn_sub_config,
                  ErrorLog::PROGRAME_CAPTURE_WARNING,
                  "compare_type is nil",
                  "比较类型没有定义")
    end
    if warn_sub_config.intervene_exp != nil
      if warn_sub_config.compare_type == "num"
        exp = "#{warn_sub_config.value_method}"+"#{warn_sub_config.compare_symbol}"+
          "#{warn_sub_config.intervene_value}"
      elsif warn_sub_config.compare_type == "str"
        if warn_sub_config.compare_symbol == 'include'
          exp = "#{warn_sub_config.value_method}"+".#{warn_sub_config.compare_symbol}"+"?(\""+
            "#{warn_sub_config.intervene_value}"+"\")"
        elsif warn_sub_config.compare_symbol == 'not include'
          exp = "!#{warn_sub_config.value_method}"+".include?(\""+
            "#{warn_sub_config.intervene_value}"+"\")"
        else
          exp = "#{warn_sub_config.value_method}"+"#{warn_sub_config.compare_symbol}"+"\""+
            "#{warn_sub_config.intervene_value}"+"\""
        end
      end
      if exp != warn_sub_config.intervene_exp 
        ErrorLog.capture_error_for_user(@platform_warn_config.target,warn_sub_config,
                    ErrorLog::PROGRAME_CAPTURE_WARNING,
                    "#{exp} != #{warn_sub_config.intervene_exp}",
                    "干预表达式配置不匹配:#{exp}")
        return false
      end
    end
    if warn_sub_config.warn_exp != nil
      if warn_sub_config.compare_type == "num"
        exp = "#{warn_sub_config.value_method}"+"#{warn_sub_config.compare_symbol}"+
          "#{warn_sub_config.warn_value}"
      elsif warn_sub_config.compare_type == "str"
        if warn_sub_config.compare_symbol == 'include'
          exp = "#{warn_sub_config.value_method}"+".#{warn_sub_config.compare_symbol}"+"?(\""+
            "#{warn_sub_config.warn_value}"+"\")"
        elsif warn_sub_config.compare_symbol == 'not include'
          exp = "!#{warn_sub_config.value_method}"+".include?(\""+
            "#{warn_sub_config.warn_value}"+"\")"
        else
          exp = "#{warn_sub_config.value_method}"+"#{warn_sub_config.compare_symbol}"+"\""+
            "#{warn_sub_config.warn_value}"+"\""
        end
      end
      if exp != warn_sub_config.warn_exp 
        ErrorLog.capture_error_for_user(@platform_warn_config.target,warn_sub_config,
                    ErrorLog::PROGRAME_CAPTURE_WARNING,
                    "#{exp} != #{warn_sub_config.warn_exp}",
                    "警告表达式配置不匹配:#{exp}")
        return false
      end
    end
    return true
  end
  
  def initialize(platform_warn_config=nil,step_wait_seconds=1,total_wait_seconds=15) 
    init_wait_step(step_wait_seconds,total_wait_seconds)
    @store_columns = {}
    if platform_warn_config
      init_hosts
      init_databases
      @platform_warn_config = platform_warn_config
      init_warn_config_arr(@platform_warn_config)
      filename = MegatrustEnviroment.get_absolute_filepath(@platform_warn_config.file_path)
      set_file(filename,@platform_warn_config.analyze_pos)
    end
  end
  
  def init_hosts
    @host_arr = Host.all
  end
  
  def init_databases
    @database_arr = Database.all
  end
  
  def reinitialize()
    begin
      @platform_warn_config.reload
      @host_arr
      @database_arr
    rescue ActiveRecord::RecordNotFound => e
      @platform_warn_config = nil
      return nil
    end
    begin
      filename = MegatrustEnviroment.get_absolute_filepath(@platform_warn_config.file_path)
      if filename != @file.path
        set_file(filename,@platform_warn_config.analyze_pos)
      end
    rescue Errno::ENOENT => e
      ErrorLog.capture_error_for_user(@platform_warn_config.target,@platform_warn_config,
        ErrorLog::PROGRAME_CAPTURE_WARNING,
        "#{e.message}(#{e.class.name}),target_name:#{@platform_warn_config.target.name}",
        "目标名:#{@platform_warn_config.target.name},指定文件无法找到:#{filename}")
    end
    init_warn_config_arr(@platform_warn_config)
  end
  
  def set_file(filename,file_pos= nil)
    @file = File.open(filename,'rb')
    @last_change_time = Time.now
    if file_pos and File.size(filename) >= file_pos
      @file.seek(file_pos)
    end
  end
  
  def timeout_file_pos_record 
    time_now = Time.now
    if (time_now - @last_change_time) > 6
      @last_change_time = time_now
      if @platform_warn_config.analyze_pos != @file.pos
        @platform_warn_config.analyze_pos = @file.pos
        @platform_warn_config.save
      end
    end
  end
  
  def capture_warning_block_forever
    while block = capture_warning_block
      hash,warn_config,block_time,target =analyze_block(block)
      if hash == {}
        return nil
      else
        return [hash,warn_config,block_time,target,block]
      end
    end
  end
  
  #提取一个块
  def capture_warning_block
    content = []
    need_wait_seconds = @total_wait_seconds
    while true
      while line = @file.gets 
        if !line.include?("\n")
          @file.seek(0-line.size,IO::SEEK_CUR)
          break
        end
        if content.size == 0 
          content << line if line.include?('######')
        else
          if !line.include?('######')
            content << line 
            if line.include?('&&&&&&')
              return content[1,content.length-2]
            end
          else
            content = []
            content << line
          end
        end 
      end
      
      sleep(@step_wait_seconds)
      need_wait_seconds -= @step_wait_seconds
      if  need_wait_seconds <= 0
        if content.size == 0
          return nil
        else
          return content[1,content.length-1]
        end
      end
      
    end
  end
  
  # 命令的比较，现在因为有参数，所以要去掉参数
  PARA_TITLE = 'GET_PARA'
  def check_value_method(real_method,value_method)
    pos = value_method.index(PARA_TITLE)
    if pos and pos > 0
      sub_real_method = real_method[0,pos]
      sub_value_method = value_method[0,pos]
      return (sub_real_method==sub_value_method)
    else
      return (real_method==value_method)
    end
  end
  
  #获得warn_config对象
  def get_warn_config(warn_config_id,value_method,block)
    @warn_config_arr.each_with_index do |wca,index|
      if wca.id == warn_config_id
        if check_value_method(value_method,wca.value_method)  
          return wca
        else
          ErrorLog.capture_error_for_user(@platform_warn_config.target,wca,
            ErrorLog::PROGRAME_CAPTURE_WARNING,
            "Unmatched warn_config's value_method: in #{wca.target_type}:#{wca.value_method}, in file:#{value_method}!",
            "命令不匹配(配置中为:#{wca.value_method}，实际文件中为:#{value_method})\n"+
            "BLOCK CONTENT:\n"+get_block_info(block))
          return nil
        end
      end 
    end
    return nil
  end
  POS_WARN_CONFIG  = 0
  POS_TARGET_ID    = 1
  POS_TARGET_TYPE  = 2
  POS_TIME         = 3
  POS_STATUS       = 4
  POS_VALUE_METHOD = 5
  HEADER_LENGTH = 6
  #分析块头
  def analyze_block_header(block_head)
    head_element_arr=block_head.strip.split(",",HEADER_LENGTH)
    return nil if head_element_arr[POS_STATUS].to_i < 0
    if head_element_arr.size==6
       block_time = Time.parse(head_element_arr[POS_TIME])
       return [head_element_arr,block_time]
    else
       return nil
    end
  end
  STORE_CON_COLUMNS=["id", "target_id", "target_type", 
    "warn_config_id", "observation_time", "key_value"]
  def instance_name_to_class_name(instance_name)
    instance_name.split("_").map!{|x| x.capitalize!}.join("")
  end
  def get_value_columns(table_name)
    value_columns = @store_columns[table_name]
    if value_columns
      return value_columns
    end
    instance_name = table_name.sub(ActiveRecord::Base.table_name_prefix,"")
    require instance_name
    class_name = instance_name_to_class_name(instance_name)
    value_columns = Kernel.const_get(class_name).column_names - STORE_CON_COLUMNS
    @store_columns[table_name] = value_columns
    value_columns
  end
  
  def insert_store_table(target,return_hash,warn_config,block_time)
    begin
      if warn_config.is_store == true
        return_hash.each do |key,data|
          if warn_config.store_type == 'UPDATE' and 
            ActiveRecord::Base.connection.select_one(gen_select_sql(target,key,data,warn_config))
            sql = gen_update_sql(target,key,data,block_time,warn_config,
              get_value_columns(warn_config.store_table_name))
            ins = ActiveRecord::Base.connection.update(sql)
          else
            sql = gen_insert_sql(target,key,data,block_time,warn_config)
            ins = ActiveRecord::Base.connection.insert(sql)
          end
          ActiveRecord::Base.connection.execute("commit")
        end   
      end
    rescue => e
      ErrorLog.capture_error_for_dev(target,warn_config,
                  ErrorLog::PROGRAME_CAPTURE_WARNING,e,
                  "warn_config_id:#{warn_config.id},warn_config_name:#{warn_config.name},generate insert_or_insert sql error!")
    end
  end
  
  def gen_insert_sql(target,key,data,block_time,warn_config)
    val = ""
    warn_config.store_col_indexs.split(',').each do |item|
      index = item.to_i
      if index > warn_config.col_count
        raise StoreColIndexError 
      end
      if index > 0
        val += "'" +data[index-1]+"',"
      else 
        val += "null,"
      end
    end
    seq = "#{warn_config.store_table_name}_seq.nextval"
    sql = "insert into #{warn_config.store_table_name}"+" values(#{seq},"+
     "#{target.id},"+"'#{target.class.name}'," +
     "#{warn_config.id},to_date('#{block_time.strftime("%Y/%m/%d %H:%M:%S")}','yyyy/mm/dd hh24:mi:ss'),'#{key}',"+
     val[0..-2]+")"
    sql
  end
  
  def gen_select_sql(target,key,data,warn_config)
    sql = "select id from #{warn_config.store_table_name} "+
      "where target_id=#{target.id} and target_type='#{target.class.name}' "+
      "and warn_config_id=#{warn_config.id} and key_value='#{key}'"
  end
  
  def gen_update_sql(target,key,data,block_time,warn_config,value_columns)
    sql = "update #{warn_config.store_table_name} set "
    where_sql = " where target_id=#{target.id} and target_type='#{target.class.name}' "+
    "and warn_config_id=#{warn_config.id} and key_value='#{key}'"
    val = ""
    col_index = 0
    warn_config.store_col_indexs.split(',').each do |item|
      index = item.to_i
      if index > 0
        val += "#{value_columns[col_index]}='" +data[index-1]+"',"
      else 
        val += "#{value_columns[col_index]}=null,"
      end
      col_index += 1
    end
    val +="observation_time=to_date('#{block_time.strftime("%Y/%m/%d %H:%M:%S")}','yyyy/mm/dd hh24:mi:ss')"
    sql = sql + val + where_sql
  end
  
  #分析整个单块
  def analyze_block(block)
    head_element_arr,block_time = analyze_block_header(block.first)
    return nil if !head_element_arr
    warn_config = get_warn_config(head_element_arr[POS_WARN_CONFIG].to_i,head_element_arr[POS_VALUE_METHOD],block)
    target      = get_target(head_element_arr[POS_TARGET_ID].to_i,head_element_arr[POS_TARGET_TYPE],block)
    if warn_config
      block_content=block[1,block.size-1]
      return_hash = analyze_block_main_content(block[1,block.size-1],warn_config)
      [return_hash,warn_config, block_time,target]
    else
      nil
    end 
  end
  
  def get_target(target_id,target_type,block)
    begin
      if target_type == "Host"
        @host_arr.each do |host|
          if target_id == host.id
            return host
          end
        end
      else
        @database_arr.each do |database|
          return database if target_id == database.id
        end
      end
      raise NilTargetError
    rescue NilTargetError => e
      ErrorLog.capture_error_for_user(@platform_warn_config.target,nil,
                  ErrorLog::PROGRAME_CAPTURE_WARNING,
                  "id:#{target_id},target_type:#{target_type} does not exist",
      "id:#{target_id},target_type:#{target_type} does not exist"+"\n"+
      "BLOCK CONTENT\n"+get_block_info(block))
    end
  end
  
  #分析主块
  def analyze_block_main_content(block_content,warn_config)
    if !warn_config
      return [{},nil]
    end
    # 删除没有任何内容行
    block_content.delete_if {|bc| bc.gsub(" ","").index("\n") == 0}
    return_hash = Hash.new() 
    index = 0
    temp_cas_arr=[]
    block_size = block_content.size
    block_content.each_with_index do |bc,ind|
      if warn_config.col_count > 0 
        cac_arr=bc.strip.split(" ",warn_config.col_count)
      else
        cac_arr=bc.strip.split(" ")
      end
      if cac_arr.size < warn_config.col_count
        if ind < block_size-1 and block_content[ind+1].index(" ") == 0    
          temp_cas_arr += cac_arr
          #加起来的数组长度小于命令返回的列数,则进入下一个循环
          if temp_cas_arr.size < warn_config.col_count
            next
          end
        else
          cac_arr = temp_cas_arr + cac_arr 
          if warn_config.name_col_index 
            if cac_arr.size < warn_config.name_col_index 
              return_hash["index:"+index.to_s] = cac_arr
            else
              return_hash["#{cac_arr[warn_config.name_col_index-1]}"] = cac_arr
            end
          else
            return_hash["#{index}"] = cac_arr
          end
          temp_cas_arr = []
          index += 1
          next
        end 
        cac_arr=temp_cas_arr
        temp_cas_arr = []
      end
      if warn_config.name_col_index
        return_hash["#{cac_arr[warn_config.name_col_index-1]}"] = cac_arr
      else
        return_hash["#{index}"] = cac_arr
      end
      index += 1
    end
    return return_hash 
  end
  
  
  def get_data_from_hash(hash,warn_sub_config)
    if warn_sub_config.name != "#default" && warn_sub_config.name != "#group_default" 
      return hash[warn_sub_config.name]
    else
      return 0
    end
  end
  
  def compare_and_insert(platfrom_warn_config,hash,warn_config,block_time,block)
    insert_count = 0
    warn_config.enable_warn_sub_configs.each do |warn_sub_config|
      if warn_sub_config.name != "#default"
        data=get_data_from_hash(hash,warn_sub_config)
        if data
          if warn_sub_config.name != "#group_default"
            insert_count += compare_and_insert_one(
                platfrom_warn_config,hash,data,warn_sub_config,
                block_time,warn_config.monitor_type,warn_sub_config.name,block)
          else
            insert_count += compare_and_insert_one(
                platfrom_warn_config,hash,data,warn_sub_config,
                block_time,warn_config.monitor_type,'group method',block)
          end
        end
      else
        hash.each do |key, data|
          issue_name = key
          if warn_config.analyze_type == 'ROW' 
            issue_name = "index"+issue_name
          end
          insert_count += compare_and_insert_one(
              platfrom_warn_config,hash,data,warn_sub_config,block_time,
              warn_config.monitor_type,issue_name,block)
        end
      end
    end
    return insert_count
  end
  
  def compare_and_insert_one(platfrom_warn_config,hash,data,warn_sub_config,
      block_time,monitor_type,issue_name,block)      
    critical_level, actual_value = compare(hash,data,warn_sub_config,block)
    if critical_level
      error_msg = gen_error_message(warn_sub_config,actual_value,issue_name,critical_level)
      issue_his = insert_into_perform_issue_history(
        platfrom_warn_config,warn_sub_config,critical_level,error_msg,block_time,monitor_type,issue_name)
      issue = insert_into_perform_issue(issue_his)
      # 发送信息
      if warn_sub_config.action_desc != nil and 
        issue.is_new_created and issue.critical_level='FATAL'
        SendMessage.add_buffer(MessageHelper.gen_message(warn_sub_config.action_desc,issue,issue_his))
      end 
      # 邮件信息
      if issue.is_new_created and issue.critical_level='FATAL'
        IssueMail.insert_by_issue(issue)
      end
      return 1
    end
    return 0
  end
  
  def get_block_info(block)
    if block == nil
      return ''
    end
    return block.join("\n")
  end
  
  def compare(hash,data,warn_sub_config,block)
    if warn_sub_config.intervene_exp == nil and warn_sub_config.warn_exp == nil
      return nil
    end
    #将data传递给实例变量@data
    set_data(data)
    #将hash传递给实例变量@hash
    set_hash(hash)
    #干预值
    begin
      if warn_sub_config.intervene_exp and eval(warn_sub_config.intervene_exp)
        critical_level="FATAL"
        return critical_level, eval("#{warn_sub_config.value_method}")
      elsif warn_sub_config.warn_exp and eval(warn_sub_config.warn_exp)
        critical_level="WARN"
        return critical_level, eval("#{warn_sub_config.value_method}")
      end
    rescue ChangeNumberError, SyntaxError => e
      ErrorLog.capture_error_for_user(@platform_warn_config.target,warn_sub_config,
        ErrorLog::PROGRAME_CAPTURE_WARNING,
        e.message+"(#{e.class.name})\n"+e.backtrace.join("\n"),
        "配置项(id:#{warn_sub_config.warn_config.id},name:#{warn_sub_config.warn_config.name}),"+
        "配置子项(id:#{warn_sub_config.id},name:#{warn_sub_config.name})\n"+"BLOCK CONTENT:\n"+get_block_info(block))
    end
    return nil
  end

  def set_data(data)
    @data = data
  end
  
  def get_data()
    @data
  end
  
  def set_hash(hash)
    @hash = hash
  end
  
  def get_hash()
    @hash
  end
  

  def gen_error_message(warn_sub_config,actual_value,issue_name,critical_level)
    if actual_value.class != String
      actual_value = sprintf("%.2f",actual_value)
    end
    if warn_sub_config.description == nil or warn_sub_config.description == ''
      error_message = warn_sub_config.error_code+":"+warn_sub_config.warn_config.name+
        " "+issue_name+" "+actual_value+" "+warn_sub_config.compare_symbol+" "
    else
      error_message = "#{warn_sub_config.error_code}:"+warn_sub_config.warn_config.name+
        " "+issue_name+" "+"(#{warn_sub_config.description}) "+
        actual_value+" "+warn_sub_config.compare_symbol+" "
    end
    if critical_level=="WARN"
      error_message += warn_sub_config.warn_value+"(预警值)"
    else
      error_message += warn_sub_config.intervene_value+"(干预值)"
    end
    error_message
  end
  
  def insert_into_perform_issue(issue_his)
    pre_issue = PerformIssue.find(:first,:conditions=>["name =? and error_code =? and target_id =? and target_type =? and status ='NEW'",
      issue_his.name,issue_his.error_code,issue_his.target_id,issue_his.target_type])
    if pre_issue
      pre_issue.issue_time = issue_his.issue_time
      pre_issue.error_msg = issue_his.error_msg
      pre_issue.critical_level = issue_his.critical_level
      pre_issue.save
      pre_issue.is_new_created = false
      return pre_issue
    else
      new_issue = PerformIssue.new
      issue_his.attributes.each do |col_name,value|
        new_issue[col_name] = value if col_name != 'id'
      end
      new_issue.save
      new_issue.is_new_created = true
      return new_issue
    end
  end
  
  def insert_into_perform_issue_history(platfrom_warn_config,warn_sub_config,critical_level,error_msg,block_time,monitor_type,name)
    issue=PerformIssueHis.new
    issue.warn_sub_config_id=warn_sub_config.id
    issue.target_id=platform_warn_config.target_id
    issue.target_type=platform_warn_config.target_type
    issue.error_msg=error_msg[0..1020]
    issue.issue_time=block_time
    issue.name ="jc"*100
    issue.error_code = warn_sub_config.error_code
    issue.status="NEW"
    issue.critical_level=critical_level
    issue.monitor_type = monitor_type
    # test
    p "start"
#    p issue
#    begin
    issue.save
#    rescue ActiveRecord::StatementInvalid=> e
#      p "ee"
#      p e
#    end
    p "save"
    
    $logger.info("insert issue!" + 
      "(id:#{issue.id},target:#{issue.target.id},#{issue.target.name})")
    return issue
  end
  
  def self.perform
    $logger = MegatrustEnviroment.get_logger('capture_warning')
    $logger.info("Capture Warning Start!svn version: 1852")
    message_thread = SendMessage.create_message_thread
    
    plat_thread_hash = {}
    time_count =  TimeCount.new(Bgconfig.get_capture_warning_replication)
    while true
      id_arr = Others.get_key_arr_and_delete(plat_thread_hash)
      if id_arr.size > 0
        platform_warn_configs = PlatformWarnConfig.find(:all,:conditions=>["is_analyze =? and id not in (#{id_arr.join(',')})",true])
      else
        platform_warn_configs = PlatformWarnConfig.find(:all,:conditions=>["is_analyze =?",true])
      end
      platform_warn_configs.each do |platform_warn_config|
        if File.exist?(platform_warn_config.file_path)
          thread = Thread.new do 
            capture_warnings_forever(platform_warn_config)
          end
          $logger.info("Start analyze!(target.type:#{platform_warn_config.target_type};target.id:#{platform_warn_config.target_id})")
          plat_thread_hash[platform_warn_config.id]= thread
        else
          file_name = MegatrustEnviroment.get_absolute_filepath(platform_warn_config.file_path)
            ErrorLog.capture_error_for_user(platform_warn_config.target,platform_warn_config,
            ErrorLog::PROGRAME_CAPTURE_WARNING,
            "target_name:#{platform_warn_config.target.name},file can't find!",
            "目标名:#{platform_warn_config.target.name},指定文件无法找到:#{file_name}")
        end
      end
      time_count.wait_to_cross
    end
  end
  
  
  def self.capture_warnings_forever(platform_warn_config)
    begin
      cw = CaptureWarning.new(platform_warn_config)
      time_count =  TimeCount.new(Bgconfig.get_capture_warning_replication)
      while true
        begin
        cw.timeout_file_pos_record
        hash,warn_config,block_time,target,block = cw.capture_warning_block_forever
        if hash
          cw.compare_and_insert(platform_warn_config,hash,warn_config,block_time,block)
          if target != nil
            cw.insert_store_table(target,hash,warn_config,block_time)
          end
        end
        rescue ActiveRecord::StatementInvalid => e
          ErrorLog.capture_error_for_dev(platform_warn_config.target,platform_warn_config,
            ErrorLog::PROGRAME_CAPTURE_WARNING,e,"BLOCK CONTENT\n"+get_block_info(block))
        end
        # reget the configs
        if time_count.cross?
          old_platform_warn_config = cw.platform_warn_config
          cw.reinitialize()
          if cw.platform_warn_config == nil or 
            cw.platform_warn_config.is_analyze == false
            $logger.info("Stop analyze!(platform_warn_config.id:#{old.id})")
            break
          else
            $logger.info("Change parameters!(target.type:#{platform_warn_config.target_type};target.id:#{platform_warn_config.target_id})")
          end          
        end
      end
    rescue Exception=> e
      #    rescue ActiveRecord::StatementInvalid=> e
      if platform_warn_config != nil
        ErrorLog.capture_error_for_dev(platform_warn_config.target,platform_warn_config,
          ErrorLog::PROGRAME_CAPTURE_WARNING,e,"BLOCK CONTENT\n"+get_block_info(block))
      else
        ErrorLog.capture_error_for_dev(nil,nil,
          ErrorLog::PROGRAME_CAPTURE_WARNING,e,'platform_warn_config is null!! ')
      end
    end
  end
  
  def get_clear_block(block,warn_config)
    if block
       if warn_config.exclude_exp
         exp = Regexp.new("#{warn_config.exclude_exp}")
         block.delete_if {|item| item =~ exp}
       else
         return block
       end
    else
       return nil
    end    
    return block
  end
  
  #分析子项配置
  def analyse_warn_sub_config(block,hash,warn_config)
        message_hash = {}
        warn_config.enable_warn_sub_configs.each do |warn_sub_config|
          begin
            if warn_sub_config.name != "#default"
              data=get_data_from_hash(hash,warn_sub_config)
              if data
                 set_data(data)
                 set_hash(hash)
                 begin
                   eval("#{warn_sub_config.value_method}")
                   message_hash[warn_sub_config.id] = 'Succeed'
                 rescue SyntaxError  => e
                   message_hash[warn_sub_config.id] = e.message
                   next          
                 end
              else
                 message_hash[warn_sub_config.id] = "Faild to get the data,please check!"
                 next
              end
            else
              hash.each do |key, data|
                 set_data(data)
                 set_hash(hash)
                 begin
                   eval("#{warn_sub_config.value_method}")
                 rescue SyntaxError  => e
                   message_hash[warn_sub_config.id] = e.message
                   break          
                 end
              end
              if !message_hash[warn_sub_config.id]
                 message_hash[warn_sub_config.id] = 'Succeed'
              end
            end
          rescue =>e
            message_hash[warn_sub_config.id] = e.to_s
            next
          end
        end
        return [block,hash,message_hash]  
  end
  
  #分析配置是否正确
  def analyse_result_content(warn_config,resutl_script,host_type,host)
    hash = {}
    if resutl_script.status=='SUCCEED'
          if resutl_script.result_content
              block = resutl_script.result_content.split("\n")
              block = get_clear_block(block,warn_config)
              if !block
                return [nil,nil,nil]
              end
              begin
                hash = analyze_block_main_content(block,warn_config)
              rescue =>e
                return [block,hash,nil]
              end
              if warn_config.is_store==true
                 hash.each do |key,value|
                     begin
                        data=value
                        block_time=Time.now
                        sql = gen_insert_sql(host,key,data,block_time,warn_config)
                     rescue =>e
                        return [block,hash,'col_index_error']
                     end
                     begin
                        ins = ActiveRecord::Base.connection.insert(sql) 
                        ActiveRecord::Base.connection.execute("rollback")
                     rescue =>e
                        return [block,hash,'store_error']
                    end          
                end
              end
              return analyse_warn_sub_config(block,hash,warn_config)
           else
              #无返回结果
              return [nil,nil,nil]
           end
    else
      return [0,0,nil]
    end
  end
end

if __FILE__ == $0 or $0.include?('control.rb') or $0.include?('mega_')
  puts "start"
  MegatrustEnviroment.set_env_and_conn
  CaptureWarning.perform
  puts "ok"
end
