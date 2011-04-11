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
# Dprinter��������ҵ���߼�����Ҫ��CLI�е�ѡ���һ��
#

class Dprinter
	@@active = nil
	@@run = false
	def initialize
		@mutex = Mutex.new             #�߳̿��Ʊ���
	end
#
#��ӦCLI�е�start����������
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
#��ӦCLI�е�stop���رշ���
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
#��ȡ�����Ψһʵ��
#

	def get_service
		@@active
	end
end