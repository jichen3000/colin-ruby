require 'net/telnet'
# require 'etc'

server = '10.160.34.152'

def ssh_exec!(ssh, command)
  stdout_data = ""
  stderr_data = ""
  exit_code = nil
  exit_signal = nil
  ssh.open_channel do |channel|
    channel.exec(command) do |ch, success|
      unless success
        abort "FAILED: couldn't execute command (ssh.channel.exec)"
      end
      channel.on_data do |ch,data|
        stdout_data+=data
      end

      channel.on_extended_data do |ch,type,data|
        stderr_data+=data
      end

      channel.on_request("exit-status") do |ch,data|
        exit_code = data.read_long
      end

      channel.on_request("exit-signal") do |ch, data|
        exit_signal = data.read_long
      end
    end
  end
  ssh.loop
  [stdout_data, stderr_data, exit_code, exit_signal]
end

# Net::SSH.start(server, Etc.getlogin) do |ssh|
#   puts ssh_exec!(ssh, "true").inspect
#   # => ["", "", 0, nil]

#   puts ssh_exec!(ssh, "false").inspect  
#   # => ["", "", 1, nil]

# end
# echo $?

fgt = Net::Telnet::new(
    "Host" => "10.160.13.107",
    "Timeout" => 5)
fgt.login("admin", "")
puts ssh_exec!(fgt, "ls").inspect
puts ssh_exec!(fgt, "mm").inspect
