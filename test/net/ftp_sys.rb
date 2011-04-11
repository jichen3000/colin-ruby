=begin
  author: Colin J
  Just change 'read' and 'write' to 'sysread' and 'syswrite'.
  Now can support named pipe. 
=end

module Net
  class FTP
    
    def storbinary_sys(cmd, file, blocksize, rest_offset = nil, &block) # :yield: data
      if rest_offset
        file.seek(rest_offset, IO::SEEK_SET)
      end
      synchronize do
        voidcmd("TYPE I")
        conn = transfercmd(cmd, rest_offset)
        loop do
          buf = file.sysread(blocksize)
          break if buf == nil
          conn.syswrite(buf)
          yield(buf) if block
        end
        conn.close
        voidresp
      end
    end
    def putbinaryfile_sys(localfile, remotefile = File.basename(localfile),
          blocksize = DEFAULT_BLOCKSIZE, &block) # :yield: data
      if @resume
        begin
          rest_offset = size(remotefile)
        rescue Net::FTPPermError
          rest_offset = nil
        end
      else
        rest_offset = nil
      end
      f = open(localfile)
      begin
        f.binmode
        storbinary("STOR " + remotefile, f, blocksize, rest_offset, &block)
      ensure
        f.close
      end
    end
  end
end