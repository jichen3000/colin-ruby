require 'hashie'

module Hashable
    def to_hash()
        the_hash = {}
        instance_variables.each do |var| 
            the_hash[var.to_s.delete("@")] = instance_variable_get(var)
        end
        the_hash
    end
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    def from_hash(the_hash)
        a = self.new
        # the_hash.each {|k,v| instance_variable_set("@{k}".to_symble,v)}
    end
  end    
end

class Some
    include Hashable
    attr_accessor :name
    def initialize(name)
        @name = name
    end
end


if __FILE__ == $0
    require 'minitest/autorun'
    require 'minitest/spec'
    require 'testhelper'

    describe "some" do
        it "function" do
            s = Some.new("colin")
            s.to_hash.must_equal({"name"=>"colin"})
            # s.instance_variable_set
            Some.from_hash({"name"=>"colin"}).pt
        end
    end
end

