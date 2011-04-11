require 'thread'
require 'singleton'
require 'drb'

#
# = dprinter.rb - Dprinter
#
# Author:: squall
# Copyright:: Copyright (c) 2008 MC soft
#
#
#
# Dprinter处理具体的业务逻辑，需要和CLI中的选项保持一致
#

class Dprinter
	@@active = nil
	@@run = false
	def initialize
		@mutex = Mutex.new             #线程控制变量
	end
#
#对应CLI中的start，启动服务
#	
	def start
		@mutex.synchronize do
			@@active = self
			@@run = true
			@drb_server = DRb::DRbServer.new('druby://localhost:8899', self)
			@print_thread = Thread.new do
				while true
					puts "this is a information~~~~~~~~~~~~~"
					sleep 3
				end
			end
		end
	end
#
#
#对应CLI中的stop，关闭服务
#
#
	def stop
		@drb_server.stop_service
		@mutex.synchronize do
			@print_thread.exit
			@@active=nil
			@@run=false
		end
	end
	def alive?
		@@run
	end
#
#获取服务的唯一实例
#

	def get_service
		@@active
	end
end