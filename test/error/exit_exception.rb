$debug_global = true

# some#test_0001_function:
# ZeroDivisionError: divided by 0
#     /Users/colin/work/GoogleDrive/ruby/test/error/exit_exception.rb:8:in `/'
#     /Users/colin/work/GoogleDrive/ruby/test/error/exit_exception.rb:8:in `test_error'
#     /Users/colin/work/GoogleDrive/ruby/test/error/exit_exception.rb:17:in `block (2 levels) in <main>'
def report_error_with_exit(the_error, custom_msg, current_method_name=nil)
    # require 'pry';binding.pry
    puts custom_msg
    if $debug_global
        # require 'pry';binding.pry
        puts  "#{the_error.class.to_s}: #{the_error.message}"
        details = the_error.backtrace
        if current_method_name
            find_flag = false
            details = details.select do |x|
                if not find_flag
                    find_flag = x.include?(current_method_name.to_s)
                end
                find_flag
            end
        end
        puts details.map{|x| " "*4+x}.join("\n")
    end
    exit(100)
end

def gen_error_details(the_error, custom_msg=nil, current_method_name=nil)
    msgs = []
    if custom_msg
        msgs << custom_msg
    end
    msgs << "#{the_error.class.to_s}: #{the_error.message}"
    details = the_error.backtrace
    if current_method_name
        find_flag = false
        details = details.select do |x|
            if not find_flag
                find_flag = x.include?(current_method_name.to_s)
            end
            find_flag
        end
    end
    msgs += details.map{|x| " "*4+x}
    msgs.join("\n")
end

def divide_zero
    1/0
end

def test_error_only_report_self_method
    begin
        divide_zero()
    rescue ZeroDivisionError => the_error
        report_error_with_exit(the_error, "Error: cannot dive zero!",__method__)
    end
end

def test_error_report_all_traceback
    begin
        divide_zero()
    rescue ZeroDivisionError => the_error
        report_error_with_exit(the_error, "Error: cannot dive zero!")
    end
end

def test_gen_error_details()
    begin
        divide_zero()
    rescue ZeroDivisionError => the_error
        gen_error_details(the_error, "Error: cannot dive zero!")
    end
end

def test_gen_error_details_self_method()
    begin
        divide_zero()
    rescue ZeroDivisionError => the_error
        gen_error_details(the_error, "Error: cannot dive zero!", __method__)
    end
end
if __FILE__ == $0
    # test_error_report_all_traceback()
    # Error: cannot dive zero!
    # ZeroDivisionError: divided by 0
    #     /Users/colin/work/GoogleDrive/ruby/test/error/exit_exception.rb:30:in `/'
    #     /Users/colin/work/GoogleDrive/ruby/test/error/exit_exception.rb:30:in `divide_zero'
    #     /Users/colin/work/GoogleDrive/ruby/test/error/exit_exception.rb:43:in `test_error_report_all_traceback'
    #     /Users/colin/work/GoogleDrive/ruby/test/error/exit_exception.rb:51:in `<main>'


    # test_error_only_report_self_method()
    # Error: cannot dive zero!
    # ZeroDivisionError: divided by 0
    #     /Users/colin/work/GoogleDrive/ruby/test/error/exit_exception.rb:35:in `test_error_only_report_self_method'
    #     /Users/colin/work/GoogleDrive/ruby/test/error/exit_exception.rb:59:in `<main>'

    # puts test_gen_error_details()
    # Error: cannot dive zero!
    # ZeroDivisionError: divided by 0
    #     /Users/colin/work/GoogleDrive/ruby/test/error/exit_exception.rb:41:in `/'
    #     /Users/colin/work/GoogleDrive/ruby/test/error/exit_exception.rb:41:in `divide_zero'
    #     /Users/colin/work/GoogleDrive/ruby/test/error/exit_exception.rb:62:in `test_gen_error_details'
    #     /Users/colin/work/GoogleDrive/ruby/test/error/exit_exception.rb:84:in `<main>'    

    puts test_gen_error_details_self_method
    # Error: cannot dive zero!
    # ZeroDivisionError: divided by 0
    #     /Users/colin/work/GoogleDrive/ruby/test/error/exit_exception.rb:79:in `test_gen_error_details_self_method'
    #     /Users/colin/work/GoogleDrive/ruby/test/error/exit_exception.rb:108:in `<main>'    
end
