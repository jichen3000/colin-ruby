require 'farm_base_conn'

#class Farmer < ActiveRecord::Base
class Farmer
  protected
  def validate
    if self.name == nil
      p "validate"
      errors.add(":name","You must supply an account name!")
    end
  end
end

f = Farmer.new
f.save



p "ok"