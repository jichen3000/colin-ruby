require 'net/ssh'


server = '10.160.34.152'
server = 'qa-host'

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

module Net; module SSH; module Connection
    class Session
        def exec_return_with_exit_code!(command)
            stdout_data = ""
            stderr_data = ""
            exit_code = nil
            exit_signal = nil
            open_channel do |channel|
                channel.exec(command) do |ch, success|
                    unless success
                        abort "FAILED: couldn't execute command (channel.exec)"
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
            loop
            [stdout_data, stderr_data, exit_code, exit_signal]
        end
    end
end; end; end


Net::SSH.start(server, 'root', :password => "fortinet") do |ssh|
  puts ssh_exec!(ssh, "ls").inspect
  puts ssh_exec!(ssh, "mm").inspect
end
Net::SSH.start(server, 'root', :password => "fortinet") do |ssh|
  puts ssh.exec_return_with_exit_code!("ls").inspect
  puts ssh.exec_return_with_exit_code!("mm").inspect
end


