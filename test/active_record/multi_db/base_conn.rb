require "rubygems"
require "activerecord"
@@config = YAML.load_file(File.join(File.dirname(__FILE__), 'database.yml'))
class LocalDatabase < ActiveRecord::Base
  establish_connection @@config['database1']
end
class RemoteDatabase < ActiveRecord::Base
  establish_connection @@config['database2']
end

module LocalDb
  class User < LocalDatabase
    belongs_to :customer
    has_on :email
  end
  class Email < LocalDatabase
    belongs_to :user
  end
end
module RemoteDb
  class User < RemoteDatabase
    belongs_to :customer
    has_on :email
  end
  class Email < RemoteDatabase
    belongs_to :user
  end
end
