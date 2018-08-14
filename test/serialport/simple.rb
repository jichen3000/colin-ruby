require 'serialport'

ser = SerialPort.new("/dev/ttyUSB0", 115200, 8, 1, SerialPort::NONE)
ser.read_timeout = 100
puts ser.read(1000)

ser.write "ls -l\n"


ser.close