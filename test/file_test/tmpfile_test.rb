require 'tempfile'
# windows D:/temp/windows/jc_tmp.2964.0
# linux /tmp/jc_tmp.30706.0
out = Tempfile.new("jc_tmp")
p out.path
puts "Dir:: tmpdir : #{Dir:: tmpdir}"
puts "Process.pid : #{Process.pid}" 

