require 'dm-core'

DataMapper.setup(:default,"oracle://colin_dev:colin_dev@megatrust")

class User
  include DataMapper::Resource
  storage_names[:default] = 'mc$ma_user'
  property :id,         Serial   # An auto-increment integer key
#  property :title,      String   # A varchar type string, for short strings
#  property :body,       Text     # A text block, for longer string data.
#  property :created_at, DateTime # A DateTime, for any date you might like.
end

p User.first