require 'activeresource'

class User < ActiveResource::Base
  self.site = 'http://172.16.4.33:3000/henry'
end

users = User.find :all
p users
p "ok"