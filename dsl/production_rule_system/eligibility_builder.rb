
$:.unshift File.dirname(__FILE__)
require 'eligibility_engine'

class EligibilityEngineBuilder

    class << self
        @@rules = []
        def build
            rule{"interview if good stock and productive"}.
                when{ is_of_good_stock and is_productive }.
                then{ mark_as_worthy_of_interview() }

            # for is_of_good_stock
            rule{"father member means good stock"}.
                when{ candidate.father.is_member }.
                then{ mark_of_good_stock() }
            rule{"military accomplishment means good stock"}.
                when{ is_militarily_accomplished }.
                then{ mark_of_good_stock() }
            rule{"Needs to be at least a captain"}.
                when{ candidate.rank >= 2 }.
                then{ mark_as_militarily_accomplished() }
            rule{"Oxbridge is good stock"}.
                when{ candidate.university == :Cambridge or 
                    candidate.university == :Oxford }.
                then{ mark_of_good_stock() }

            # for is_productive
            rule{"Productive Englishman"}.
                when{ candidate.nationality == :England and 
                    candidate.annual_income >= 10000 }.
                then{ mark_as_productive() }
            rule{"Productive Scotsman"}.
                when{ candidate.nationality == :Scotland and 
                    candidate.annual_income >= 20000 }.
                then{ mark_as_productive() }
            rule{"Productive American"}.
                when{ candidate.nationality == :UnitedStates and 
                    candidate.annual_income >= 80000 }.
                then{ mark_as_productive() }
            rule{"Productive Solider"}.
                when{ is_militarily_accomplished and 
                    candidate.annual_income >= 8000 }.
                then{ mark_as_productive() }

            engine
        end

        def rule(&description_proc)
            @@description = description_proc
            self
        end
        def when(&condition_proc)
            @@condition = condition_proc
            self
        end
        def then(&action_proc)
            rule = EligibilityRule.new(@@description, @@condition, action_proc)
            @@rules.push(rule)
            @@description = nil
            @@condition = nil
            rule
        end
        def engine
            EligibilityEngine.new(@@rules)
        end
    end
end

if __FILE__ == $0
    require 'minitest/spec'
    require 'minitest/autorun'
    describe EligibilityEngineBuilder do
        it "can build an eligibale engine." do
            engine = EligibilityEngineBuilder.build()

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
