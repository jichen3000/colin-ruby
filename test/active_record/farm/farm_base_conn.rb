require "activerecord"

ActiveRecord::Base.establish_connection(
#  :adapter  => "oracle",
#  :database => "mc32",
#  :username => "colin",
#  :password => "colin",
#  :host     => "mc32"  
  :adapter  => "oracle",
  :database => "colin",
  :username => "colin",
  :password => "colin",
  :host     => "colin-book"  
)

class Farmer < ActiveRecord::Base
#  self.table_name='farmer'
  has_many :cows
#  has_and_belongs_to_many :resellers
  has_many :distributors
  has_many :resellers, :through => :distributors
  has_one :address_other, :as => :addressable, :class_name => 'Address'
#  protected
#  def validate
#    if self.name == nil
#      p "validate"
#      errors.add(":name","You must supply an account name!")
#    end
#  end
end
    
class Cow < ActiveRecord::Base
  self.table_name='cows'
  belongs_to :farmer
end

class Reseller < ActiveRecord::Base
#  self.table_name='reseller'
#  has_and_belongs_to_many :farmers
  has_many :distributors
  has_many :farmers, :through => :distributors
  has_one :address_other, :as => :addressable, :class_name => 'Address'
end

class Distributor < ActiveRecord::Base
  belongs_to :reseller
  belongs_to :farmer
end 

class Address < ActiveRecord::Base
  belongs_to :addressable, :polymorphic => true
end

