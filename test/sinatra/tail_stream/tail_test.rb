require 'file/tail'
require 'timeout'
# require 'test_helper'

class TailHelper
    def self.wait_last_line(file_path, timeout_seconds=20, &block)
        height = 1
        last_line = ""
        Timeout.timeout(timeout_seconds) do
            File::Tail::Logfile.open(file_path, :break_if_eof => false) do |log|
                log.interval = 1
                log.max_interval = 2
                lines = log.tail(height) #{ |line| cur_index=line.to_i}
                last_line = lines.last
                # puts last_line
                # STDOUT.flush
                if not block.call(last_line)
                    redo
                end
            end
            return last_line
        end
    end
    def self.wait_first_line(file_path, timeout_seconds=20, &block)
        height = 1
        first_line = nil
        Timeout.timeout(timeout_seconds) do
            File::Tail::Logfile.open(file_path, :break_if_eof => false) do |log|
                log.interval = 0.5
                log.max_interval = 1
                lines = log.tail(height) #{ |line| cur_index=line.to_i}
                first_line = lines.first
                # puts first_line
                # STDOUT.flush
                if not block.call(first_line)
                    redo
                end
            end
            return first_line
        end
    end
    def self.wait_exists(file_path, timeout_seconds=20, interval=0.5)
        Timeout.timeout(timeout_seconds) do
            while not File.exists?(file_path)
                # puts "sleep #{interval}"
                sleep(interval)
            end
        end
        true
    end
end


if __FILE__ == $0
    require 'minitest/autorun'
    require 'minitest/spec'
    require 'testhelper'

    CUR_DIR = File.dirname(__FILE__)

    describe "some" do
        # it "wait_last_line" do
        #     file_path = File.join(CUR_DIR,"progress_in_bp.log")
        #     begin
        #         timeout_seconds = 5
        #         last_line = TailHelper.wait_last_line(file_path, timeout_seconds) do |last_line|
        #             last_line.to_i > 80
        #         end
        #     rescue Timeout::Error => e
        #         raise "Error: timeout(#{timeout_seconds})!"
        #     end
        # end
        it "wait_first_line" do
            file_path = File.join(CUR_DIR,"progress_in_bp.log")
            begin
                timeout_seconds = 20
                first_line = TailHelper.wait_first_line(file_path, timeout_seconds)
                first_line.pt
            rescue Timeout::Error => e
                raise "Error: timeout(#{timeout_seconds})!"
            end
        end
    end
end
