cur_output = File.open("output.log","w")
thread_1 = Thread.new do
    # Thread.current[:stdout] = StringIO.new
    $stdout = cur_output
    i = 0
    while i < 4
        puts "i: #{i}"
        i += 1
        sleep(1)
    end
    Thread.current[:result] = i

end
cur_output1 = File.open("output1.log","w")
thread_2 = Thread.new do
    # Thread.current[:stdout] = StringIO.new
    $stdout = cur_output1
    i = 0
    while i < 5
        puts "i: #{i}"
        i += 1
        sleep(1)
    end
    Thread.current[:result] = i

end
thread_1.join()
thread_2.join()
cur_output.close

