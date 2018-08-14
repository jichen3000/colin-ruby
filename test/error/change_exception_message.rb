def do_some()
    begin
        1/0
    rescue Exception => e
        raise $!, "Problem with string number : #{$!}", $!.backtrace
    end
end

def main()
    begin
       do_some 
    rescue Exception => e
        puts(e.inspect + "\n" + 
                e.backtrace.join("\n"))
    end
end

main()