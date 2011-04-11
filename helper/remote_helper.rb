class RemoteHelper
  class << self
    def sftp_upload_files(host,user,pwd,files,options={})      
      require 'net/sftp'
      set_default_options(options)
      Net::SFTP.start(host,user, :password=>pwd, :port=>options[:ssh_port]) do |sftp|
        trans_files(sftp,files)
        remove_files(sftp,files) if options[:is_remove]
      end      
    end
    def ssh_do_cmds(host,user,pwd,cmds,options={})
      require 'net/ssh'
      set_default_options(options)
      Net::SSH.start(host,user, :password=>pwd, :port=>options[:ssh_port]) do |ssh|
        do_cmds(ssh,cmds)
      end
    end
    def ssh_files_and_cmds(host,user,pwd,upload_files,cmds,download_files=[],options={})
      require 'net/ssh'
      require 'net/sftp'
      set_default_options(options)
      Net::SSH.start(host,user, :password=>pwd, :port=>options[:ssh_port]) do |ssh|
        upload_files(ssh.sftp,upload_files)
        do_cmds(ssh,cmds)
        download_files(ssh.sftp,download_files) if download_files.size>0
        remove_files(ssh.sftp,files) if options[:is_remove]
      end
    end
    def upload_files(sftp,files)
      files.each do |f_object|
        # 检查目录是否存在，不存在就创建。
        begin
          sftp.stat!(f_object[2]).directory?
        rescue Net::SFTP::StatusException => se
          raise unless se.code == 2
          sftp.mkdir!(f_object[2],:permissions => 0775)
          puts("dir(#{f_object[2]}) is created!")
        end
        source_name = File.join(f_object[1],f_object[0])
        target_name = File.join(f_object[2],f_object[0])
        sftp.upload!(source_name,target_name)
        puts("source file(#{source_name}) upload target file(#{target_name})")
      end
    end
    def download_files(sftp,files)
      files.each do |f_object|
        source_name = File.join(f_object[1],f_object[0])
        target_name = File.join(f_object[2],f_object[0])
        sftp.download!(source_name,target_name)
        puts("source file(#{source_name}) download target file(#{target_name})")
      end
    end
    
    def remove_files(sftp,files)
      files.each do |f_object|
        # 检查目录是否存在，不存在就创建。
        target_name = File.join(f_object[2],f_object[0])
        begin
          sftp.stat!(f_object[2]).file?
          sftp.remove!(target_name)
          puts("target file(#{target_name}) had been removed!")
        rescue Net::SFTP::StatusException => se
          raise unless se.code == 2
          puts("target file(#{target_name}) doesn't exist!")
        end
      end
    end
    def do_cmds(ssh,cmds)
      cmds.each do |str|
        ssh.exec(str)
        puts("do cmd: "+str)
      end
    end
    private
    def set_default_options(options)
      options[:is_remove]||=false
      options[:ssh_port]||=22
    end
  end
end