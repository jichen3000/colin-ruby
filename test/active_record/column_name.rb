require 'activerecord'

class Managerdb < ActiveRecord::Base
  self.establish_connection(
    :adapter  => "oracle_enhanced",
    :encoding => "utf-16",
    :database => "28drb",
    :username => "mcdbra3",
    :password => "mcdbra3",
    :host     => "28drb"
  )
end
class DrSystem < Managerdb
  self.table_name='mc$dr_system'
  set_primary_key :bs_id
#  has_many :subs, :class_name => "DrSubSystem", :foreign_key => "sub_id"
end

p DrSystem.find(1)