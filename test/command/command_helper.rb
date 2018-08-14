require 'open3'

def run_command(cmd_str)
    output = ""
    error = ""
    start_time = Time.now
    Open3.popen3(cmd_str) do |stdin, stdout, stderr, wait_thr|
      while line = stdout.gets
        puts line
        output += line
      end
      error = stderr.read
    end
    end_time = Time.now
    result = if error.empty?
        {"is_successful"=>true, "output"=>output}
    else
        {"is_successful"=>false, "output"=>error}
    end
    result["cmd"] = cmd_str
    result["seconds"] = end_time - start_time
    result
end

if __FILE__ == $0
    require 'minitest/autorun'
    require 'minitest/spec'
    require 'testhelper'

    describe "some" do
        it "run_command" do
            cmd_str = 'ping -c 3 www.google.com'
            run_command(cmd_str).pt
            # cmd_str = 'ls mmm'
            # run_command(cmd_str).pt
        end
    end
end