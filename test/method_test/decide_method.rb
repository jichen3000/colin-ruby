Department = Struct.new(:name)
Grade = Struct.new(:score)
Employee = Struct.new(:name)

class Admit
    def self.check(admit_obj, employee)
        Admit.send(admit_obj.class.to_s.downcase, employee)
    end
    def self.department(employee)
        p __method__
        p employee
    end
    def self.grade(employee)
        p __method__
        p employee
    end
end

# Department.include(Admit)

d = Department.new(:d)
g = Grade.new(5)
colin = Employee.new("Colin")

Admit.check(d, colin)
Admit.check(g, colin)
# d.check
# Admit.check

# d_hash = {:type=>:department, :name=>}
