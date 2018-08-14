log_name = "test.log"
cur_log = File.open(log_name,'a')
cur_log.sync = true
cur_log.instance_eval do
    self.class.send :alias_method, :origin_write, :write
    self.class.send :alias_method, :origin_puts, :puts
    define_singleton_method(:save_puts_with_br) do |msg|
        if not self.closed?
            STDOUT.puts("in save_puts_with_br")
            self.origin_puts("#{msg}<br/>")
        end
    end
    define_singleton_method(:save_write) do |msg|
        if not self.closed?
            STDOUT.puts("in save_write")
            self.origin_write(msg)
        end
    end
    alias :write :save_write
    alias :puts :save_puts_with_br
end 
# def cur_log.save_puts_with_br(msg)
#     if not self.closed?
#         self.puts("#{msg}<br/>")
#     end
# end
# def cur_log.save_write(msg)
#     if not self.closed?
#         self.write(msg)
#     end
# end


cur_log.origin_write("some")
cur_log.write("some")
cur_log.save_write("some")