require 'rawio'

class MultiFile
	class << self
		def exist?(filename)
			r = false
			if self.rawfile?(filename)
				r = RawIO::exist?(filename)
			else
				r = File.exist?(filename)
			end
			r
		end
		def rawfile?(filename)
			RawIO::rawfile?(filename)
		end
	end
	def initialize(filename,mode)
		@file = nil
		if MultiFile.exist?(filename)
			raise "file(#{filename} not exist! now not support create new file!!)"
		end
		if MultiFile.rawfile?(filename)
			@file = RawIO::RawFile.new
			@file.open(filename,mode)
			@format = 'Raw'
		else
			@file = File.new(filename,mode)
			@format = 'Normal'
		end
	end
	def seek(amount,whence=IO::SEEK_SET)
		@file.seek(amount,whence)
	end
	def write(string)
		@file.write(string)
	end
	def read(amount)
		@file.read(amount)
	end
	def path
		@file.path
	end
	def close
		@file.close
	end
	def tell
		@file.tell
	end
	def pos
		@file.pos
	end
end