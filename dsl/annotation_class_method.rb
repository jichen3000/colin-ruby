# from DSL change 42


# module DomainModule
#     @@validations = {}
#     def self.valid_range name, range
#         @@validations[self] ||= []
#         v = lambda do |obj|
#             range.include?(obj.instance_variable_get("@" + name.to_s))
#         end
#         @@validations[self] << v
#     end
#     def valid?
#         return @@validations[self.class].all? {|v| v.call(self)}
#     end
# end

# this class has the same effect of DomainObject
class DomainObjectSame
    @@validations = {}
    def self.valid_range name, range
        @@validations[self] ||= []
        v = lambda do |obj|
            range.include?(obj.instance_variable_get("@" + name.to_s))
        end
        @@validations[self] << v
    end
    def valid?
        return @@validations[self.class].all? {|v| v.call(self)}
    end
end

class DomainObject
    class << self; attr_accessor :validations; end
    def self.valid_range name, range
        @validations ||= []
        v = lambda do |obj|
            range.include?(obj.instance_variable_get("@"+name.to_s))
        end
        @validations << v
    end
    def valid?
        return self.class.validations.all? {|v| v.call(self)}
    end
end

# this module has the same effect of DomainObject. But I much prefer this, since in Ruby using module will be better than class.
module DomainModule
    def self.included(base)
        base.extend(ClassMethod)
    end
    def valid?
        return self.class.validations.all? {|v| v.call(self)}
    end
    module ClassMethod
        attr_accessor :validations
        def valid_range name, range
            @validations ||= []
            v = lambda do |obj|
                range.include?(obj.instance_variable_get("@"+name.to_s))
            end
            @validations << v
        end
    end

end

# class PatientVisit < DomainObjectSame
class PatientVisit
    include DomainModule
    # include DomainModule
    attr_accessor :height, :weight
    valid_range :height, 1..120
    valid_range :weight, 1..1000
    def initialize height, weight
        @height = height
        @weight = weight
    end
end

patient_visit = PatientVisit.new(100, 500)
p patient_visit.valid?