
# :nodoc:
# Version:: $Id: rollingfileoutputter.rb,v 1.4 2003/09/12 23:55:43 fando Exp $

require "log4r/outputter/fileoutputter"
require "log4r/outputter/RollingFileOutputter"
require "log4r/staticlogger"

module Log4r

  # RollingFileOutputter - subclass of FileOutputter that rolls files on size
  # or time. Additional hash arguments are:
  #
  # [<tt>:maxsize</tt>]   Maximum size of the file in bytes.
  # [<tt>:maxtime</tt>]   Maximum age of the file in seconds.
  # [<tt>:filemaxcount</tt>]   Maximum file.
  class RollingOverFileOutputter < RollingFileOutputter

#    attr_reader :count, :maxsize, :maxtime, :startTime, :filemaxcount#,i:baseFilename
    attr_reader :filemaxcount

    def initialize(_name, hash={})
      if hash.has_key?(:filemaxcount) || hash.has_key?('filemaxcount') 
        _filemaxcount = (hash[:filemaxcount] or hash['filemaxcount']).to_i
        if _filemaxcount.class != Fixnum
          raise TypeError, "Argument 'filemaxcount' must be an Fixnum", caller
        end
        if _filemaxcount == 0
          raise TypeError, "Argument 'filemaxcount' must be > 0", caller
        end
        @filemaxcount = _filemaxcount
      end
      # must set trunc is true.
      hash[:trunc] = true
      super(_name, hash)      
    end

    #######
    private
    #######

    # construct a new filename from the count and baseFilname
    def makeNewFilename
#      pad = "0" * (6 - @count.to_s.length) + count.to_s
      if @filemaxcount and @filemaxcount> 0
        index = (@count % @filemaxcount )
        index_length = @filemaxcount.to_s.length
      else
        index = @count
        # note use of hard coded 6 digit counter width - is this enough files?
        index_length = 6
      end
      pad = "0" * (index_length - index.to_s.length) + index.to_s
      newbase = @baseFilename.sub(/(\.\w*)$/, pad + '\1')
      
      write_cur_filename(newbase)
      
      @filename = File.join(File.dirname(@filename), newbase)
      Logger.log_internal {"File #{@filename} created"}
    end 
    def write_cur_filename(newbase)
      file = File.new(@baseFilename,'w')
      file << newbase
      file.close      
    end
  end

end

# this can be found in examples/fileroll.rb as well
#if __FILE__ == $0
#  require 'log4r'
#  include Log4r
#
#
#  timeLog = Logger.new 'WbExplorer'
#  timeLog.outputters = RollingFileOutputter.new("WbExplorer", { "filename" => "TestTime.log", "maxtime" => 10, "trunc" => true })
#  timeLog.level = DEBUG
#
#  100.times { |t|
#    timeLog.info "blah #{t}"
#    sleep(1.0)
#  }
#
#  sizeLog = Logger.new 'WbExplorer'
#  sizeLog.outputters = RollingFileOutputter.new("WbExplorer", { "filename" => "TestSize.log", "maxsize" => 16000, "trunc" => true })
#  sizeLog.level = DEBUG
#
#  10000.times { |t|
#    sizeLog.info "blah #{t}"
#  }
#
#end
