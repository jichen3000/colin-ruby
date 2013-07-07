

class Substance
    attr_reader :name
    def initialize(name, recipe_time_stamp)
        @name = name
        @inputs = []
        @profile = nil
        @recipe = Recipe.new(recipe_time_stamp)

    end
    def add_input(input)
        @inputs.push(input)
    end
    def get_profile
        invoke_profile_calculation
        @profile
    end
    def invoke_profile_calculation
        @inputs.each{|input| input.invoke_profile_calculation}
        if out_of_date?
            @profile = ProfilingService.calculate_profile(self);
        end
    end
    def out_of_date?
        return true if not @profile
        @profile.time_stamp < @recipe.time_stamp or
            @inputs.any? {|input| input.updated_after?(@profile.time_stamp)}
    end
    def updated_after?(time_stamp)
        @profile.time_stamp > time_stamp
    end
end

Profile = Struct.new(:time_stamp)
Recipe = Struct.new(:time_stamp)

class ProfilingService
    def self.calculate_profile(substance)
        # p "calculate_profile substance:",substance
        Profile.new(Time.now)
    end
end

if __FILE__ == $0
    require 'minitest/spec'
    require 'minitest/autorun'

    describe Substance do
        it "can invoke" do
            ProfilingService.class_eval do
                class_variable_set(:@@records, [])
                class << self
                    alias_method :origin_calculate_profile, :calculate_profile
                    def calculate_profile(substance)
                        records() << substance.name
                        origin_calculate_profile(substance)
                    end
                    def records
                        class_variable_get(:@@records)
                    end
                end
            end
            health_potion = Substance.new("Health Portion", Time.new(2013,3,5))
            clarified_water = Substance.new("Clarified Water", Time.new(2013,3,2))
            dessicated_glass = Substance.new("Dessicated Glass", Time.new(2013,3,1))
            octopus_essence = Substance.new("Octopus Essence", Time.new(2013,3,4))
            octopus = Substance.new("Octopus", Time.new(2013,3,3))

            health_potion.add_input(clarified_water)
            health_potion.add_input(octopus_essence)

            clarified_water.add_input(dessicated_glass)

            octopus_essence.add_input(clarified_water)
            octopus_essence.add_input(octopus)

            health_potion.get_profile
            ProfilingService.records.must_equal(["Dessicated Glass", 
                "Clarified Water", "Octopus", "Octopus Essence", "Health Portion"])
        end
        
    end
end