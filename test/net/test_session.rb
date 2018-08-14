require 'net/ssh'
require 'testhelper'
Net::SSH.start('qa-host','root',:password=>'fortigate', :timeout => 2) do |ssh|
  # puts ssh.send_message("pwd; cd /home; pwd")
  # puts ssh.exec!("cd /home")
  # puts ssh.exec!("pwd")
    status = nil
  ssh.open_channel do |channel|
    channel.request_pty
  #   puts 1
    exit_code = nil
    channel.on_data do |ch, data|
      puts "got stdout: #{data}"
      # channel.send_data "something for stdin\n"
    end
    channel.on_extended_data do |ch, type, data|
      puts "got stderr: #{data}"
    end

    channel.on_close do |ch|
      puts "channel is closing!"
    end
    channel.on_open_failed do |ch, code, desc|
      puts "channel is on_open_failed!"
      puts code
      puts desc
    end
    channel.on_eof do |ch|
      puts "remote end is done sending data"
      status = 1
    end
    channel.on_request("exit-status") do |ch,data|
        exit_code = data.read_long
    end

    channel.on_request("exit-signal") do |ch, data|
        exit_signal = data.read_long
    end
    # channel.wait
    channel.exec("cd /home") do |ch, success|
      abort "could not execute command" unless success
    end
    ssh.loop(1) {status != 1}
    # while (status != 1) do
    #   ssh.loop
    #   puts "sleep"
    #   sleep(1)
    # end
    status = nil
    # puts channel.active?
    # channel.send_data("pwd\n")
    # channel.eof!
  end
ssh.open_channel do |channel|
      channel.exec("pwd") do |ch, success|
      puts "could not execute command" unless success
      abort "could not execute command" unless success
      channel.on_data do |ch, data|
        puts "got stdout: #{data}"
        # channel.send_data "something for stdin\n"
      end
      channel.on_extended_data do |ch, type, data|
        puts "got stderr: #{data}"
      end
    channel.on_eof do |ch|
      puts "remote end is done sending data"
      status = 1
    end
    end
    ssh.loop(1) {puts "loop "; status != 1}
    # while (status != 1) do
    #   ssh.loop
    #   puts "sleep"
    #   sleep(1)
    # end
    # puts channel.output
      # channel.exec("pwd") do |ch, success|
      #   abort "could not execute command" unless success
      # end
  end

end
