require 'net/telnet'

def main(fortigate_port)
    fgt = Net::Telnet::new(
        "Host" => "10.160.13.254",
        "Port" => 23,
        "Timeout" => 5,
        "Waittime" => 1,
        "Output_log"=>"output.log",
        "Prompt" => /#|>/)

    fgt.cmd("fortinet")
    fgt.cmd("String"=>"enable", "Match"=>/Password:/)
    fgt.cmd("fortinet")

    fgt.puts("enable")
    fgt.waitfor("Match"=>/Password:/)
    fgt.cmd("fortinet")


    fgt.write("enable\n")
    fgt.waitfor("Match"=>/nable/, "Timeout"=>30)
    fgt.cmd("fortinet")

    fgt.close
end

if __FILE__ == $0
    require 'testhelper'

end

