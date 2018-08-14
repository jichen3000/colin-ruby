require 'serialport'
require 'timeout'
class EasySerialPort
    attr_reader :connect
    def initialize(device_name, baud=115200, timeout=5, options={})
        @connect = SerialPort.new(device_name, baud, 8, 1, SerialPort::NONE)
        @connect.read_timeout = 100
        @match = Regexp.new("#")
        @interval = 0.1
        @timeout = timeout
    end
    def cmd(cmd_str)
        result = ""
        Timeout.timeout(@timeout) do
            exit_code = @connect.write("#{cmd_str}\n")
            if exit_code >= 0
                result = @connect.read(2048)
                while not result.match(@match)
                    sleep(@interval)
                    result += @connect.read(2048)
                end
            else
                raise "Running command (#{cmd_str}) failed, exit code: #{exit_code}"
            end
        end
        result
    end
    def close()
        @connect.close()
    end
end

if __FILE__ == $0
    ser = EasySerialPort.new("/dev/ttyUSB0")
    ser.cmd("ls -l")
    require 'minitest/autorun'
    require 'minitest/spec'
    require 'testhelper'

    describe "some" do
        it "function" do
        end
    end
end