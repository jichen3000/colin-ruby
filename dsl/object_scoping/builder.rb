$:.unshift File.dirname(__FILE__)

class MinimumGradeExpr
    @@grade_int = {:director=>1, :ceo=>2}
    def initialize(minimum_grade)
        @minimum_grade = minimum_grade
    end
    def check(employee)
        employee.grade and @@grade_int[employee.grade] >= @@grade_int[@minimum_grade]
    end
end
class DepartmentExpr
    def initialize(department)
        @department = department
    end
    def check(employee)
        employee.department == @department
    end
end
class EndDateExpr
    def initialize(year, month, day)
        @end_date = Time.new(year, month, day)
    end 
    def check(employee)
        @end_date > Time.now
    end
end
class TimeOfDayExpr
    def initialize(begin_int, end_int)
        @begin_int = begin_int
        @end_int = end_int
    end
    def check(employee)
        employee.time_int >= @begin_int and employee.time_int <= @end_int 
    end
end
class AndExpr
    def initialize(exprs)
        @exprs = exprs
    end
    def check(employee)
        @exprs.all?{|expr| expr.check(employee)}
    end
end
class AllowRule
    def initialize(body)
        @body = body
    end
    def admit?(employee)
        @body.check(employee) ? :admit : :no_option
    end
end
class RefuseRule
    def initialize(body)
        @body = body
    end
    def admit?(employee)
        @body.check(employee) ? :refuse : :no_option
    end
end
class Zone
    def initialize()
        @rules = []
    end
    def add_rule(rule)
        @rules.push(rule)
    end
    def admit?(employee)
        @rules.each do |rule| 
            # p rule,rule.admit?(employee)
            case rule.admit?(employee)
            when :admit then return true
            when :refuse then return false
            when :no_option then "pass"
            else raise "Invalid option!"
            end
        end
        # @rules.all?{|rule| rule.admit?(employee)==:ADMIN}
    end
end
class Builder
    def load_file file_name
        @zone = Zone.new
        instance_eval(File.readlines(file_name).join("\n"))
        @zone
    end
    def allow expr = nil, &block
        p "allow",expr, block
        rule = AllowRule.new(form_expression(expr, &block))
        # p "allow rule", rule
        @zone.add_rule rule
    end
    def refuse expr = nil, &block
        p "refuse",expr, block
        rule = RefuseRule.new(form_expression(expr, &block))
        # p "refuse rule", rule
        @zone.add_rule rule
    end
    def form_expression expr = nil, &block
        # p "form",expr, block
        if block_given?
            AndExprBuilder.interpret(&block)
        else 
            expr
        end 
    end
    def grade_at_least grade_symbol
        MinimumGradeExpr.new grade_symbol
    end
    def department(name)
        DepartmentExpr.new(name)
    end
    def ends(year, month, day)
        EndDateExpr.new(year, month, day)
    end
end
class AndExprBuilder
    def initialize &block
        @rules = []
        @block = block
    end
    def self.interpret &block
        self.new(&block).value
    end
    def value
        instance_eval(&@block)
        AndExpr.new(@rules)
    end
    def grade_at_least grade_symbol
        @rules << MinimumGradeExpr.new(grade_symbol)
    end
    def department(name)
        @rules << DepartmentExpr.new(name)
    end
    def ends(year, month, day)
        @rules << EndDateExpr.new(year, month, day)
    end
    def during(begin_int, end_int)
        @rules << TimeOfDayExpr.new(begin_int,end_int)
    end
end

Employee = Struct.new(:department, :grade, :time_int)
if __FILE__ == $0
    require 'minitest/spec'
    require 'minitest/autorun'
    describe Builder do
        it "can build a script file" do
            colin = Employee.new(:mf)
            build = Builder.new.load_file('simple_script.txt')
            build.admit?(colin).must_equal true
        end
    end
end