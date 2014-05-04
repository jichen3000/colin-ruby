$:.unshift File.dirname(__FILE__)

require 'erb'

@comment = "it is just an example!"
@names = ["jc","any"]
# notice, using trim_mode
renderer = ERB.new(File.read("simple_py.erb"), nil,"-")
puts output =  renderer.result()
File.write("simple.py", renderer.result())