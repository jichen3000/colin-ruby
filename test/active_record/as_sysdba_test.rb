require 'activerecord'
require 'oci8'
#module ActiveRecord
#  class OCI8AutoRecover < DelegateClass(OCI8) #:nodoc:
#    def initialize(config, factory = OracleConnectionFactory.new)
#      @active = true
#      @username, @password, @database, = config[:username].to_s, config[:password].to_s, config[:database].to_s
#      @async = config[:allow_concurrency]
#      @prefetch_rows = config[:prefetch_rows] || 100
#      @cursor_sharing = config[:cursor_sharing] || 'similar'
#      @factory = factory
#      p "jcjc"
#      @connection  = @factory.new_connection @username, @password, @database, @async, @prefetch_rows, @cursor_sharing
#      super @connection
#    end
#  end
#end

class ColinDb < ActiveRecord::Base
  self.establish_connection(
  :adapter  => "oracle",
#  :database => "'dbra10g as sysdba'",
  :database => "dbra10g",
  :username => "sys",
  :password => "oracle",
#  :username => "drb",
#  :password => "drbmc",
#  :host     => "dbra10g"
  :host     => "dbra10g",
  :privilege     => :SYSDBA
  )
  class << self
    def dosql(sql)
      p ColinDb.connection
#      ColinDb.connection = OCI8.new "sys", "oracle", "dbra10g", :SYSDBA
      ColinDb.connection.execute(sql)
    end
  end
end
#class JobInfo < ColinDb
#  self.table_name = "OLAP_OLEDB_MEASURES"
#  def test_str
#    "self.name : #{name}"
#  end
#end

p ColinDb.dosql('select * from tab')
p "ok"