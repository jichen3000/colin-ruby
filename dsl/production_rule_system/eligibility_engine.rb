
Person = Struct.new(:name, :university, :nationality, :annual_income)
class Application
    attr_reader :candidate, :is_of_good_stock, :is_worthy_of_interview, 
    :is_militarily_accomplished, :is_productive

    def mark_of_good_stock
        @is_of_good_stock = true
    end
    def mark_as_worthy_of_interview
        @is_worthy_of_interview = true
    end
    def mark_as_militarily_accomplished
        @is_militarily_accomplished = true
    end
    def mark_as_productive
        @is_productive = true
    end
    def initialize(candidate)
        @candidate = candidate
        @is_of_good_stock = false
        @is_worthy_of_interview = false
        @is_militarily_accomplished = false
        @is_productive = false
    end
end

class EligibilityRule
    attr_reader :condition, :action
    attr_accessor :description
    def initialize(description, condition, action)
        @description = description
        @condition = condition
        @action = action
    end
    def can_activate(application)
        begin
            # p application
            # p @condition
            return application.instance_eval(&@condition)
        rescue NoMethodError => e
            # raise e
            return false
        end
    end
    def fire(application)
        application.instance_eval(&@action)
        # @action.call(application)
    end
end

class EligibilityEngine
    attr_reader :rules, :fired_log, :available_rules, :agenda
    def initialize(rules=[])
        @rules = rules

        # List<EligibilityRule>
        @agenda = []
        # List<EligibilityRule>
        @fired_log = []
    end
    def run(application)
        @available_rules = @rules.clone
        activate_rules(application)
        while (@agenda.size > 0) do
            fire_rules_on_agenda(application)
            activate_rules(application)
        end
    end
    def add_rule(description, condition, action)
        @rules.push(
            EligibilityRule.new(description, condition, action))
    end
    private 
    def activate_rules(application)
        @agenda += @available_rules.select {|rule| rule.can_activate(application)}
        @available_rules -= @agenda
    end
    def fire_rules_on_agenda(application)
        while (@agenda.size > 0) do
            fire(@agenda.first(), application)
        end
    end
    def fire(rule, application)
        rule.fire(application)
        @fired_log.push(rule.description)
        @agenda.delete(rule)
    end
end

if __FILE__ == $0
    require 'minitest/autorun'
    require 'minitest/spec'
    describe EligibilityEngine do
        it "can run" do
            engine = EligibilityEngine.new

            engine.add_rule(
                "interview if good stock and productive",
                proc { is_of_good_stock and is_productive },
                proc { mark_as_worthy_of_interview()})

            # for is_of_good_stock
            engine.add_rule(
                "father member means good stock",
                proc { candidate.father.is_member },
                proc { mark_of_good_stock() })
            engine.add_rule(
                "military accomplishment means good stock",
                proc { is_militarily_accomplished },
                proc { mark_of_good_stock() })
            engine.add_rule(
                "Needs to be at least a captain",
                proc { candidate.rank >= 2 },
                proc { mark_as_militarily_accomplished() })
            engine.add_rule(
                "Oxbridge is good stock",
                proc { candidate.university == :Cambridge or 
                    candidate.university == :Oxford },
                proc { mark_of_good_stock()  })

            # for is_productive
            engine.add_rule(
                "Productive Englishman",
                proc { candidate.nationality == :England and 
                    candidate.annual_income >= 10000 },
                proc { mark_as_productive() })
            engine.add_rule(
                "Productive Scotsman",
                proc { candidate.nationality == :Scotland and 
                    candidate.annual_income >= 20000 },
                proc { mark_as_productive() })
            engine.add_rule(
                "Productive American",
                proc { candidate.nationality == :UnitedStates and 
                    candidate.annual_income >= 80000 },
                proc { mark_as_productive() })
            engine.add_rule(
                "Productive Solider",
                proc { is_militarily_accomplished and 
                    candidate.annual_income >= 8000 },
                proc { mark_as_productive() })

            john = Person.new("john", :Pekin, :England, 15000)
            john_applicaiton = Application.new(john)
            john.instance_eval do 
                @rank = 3 
                def rank
                    @rank
                end
            end
            
            engine.run(john_applicaiton)
            john_applicaiton.is_worthy_of_interview.must_equal(true)
        end
    end
end