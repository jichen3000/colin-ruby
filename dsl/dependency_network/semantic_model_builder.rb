$:.unshift File.dirname(__FILE__)
require 'combinator_parser'
require 'potion_lexer'
require 'potions'

class PotionSemanticModelBuilder
    @@obj_hash = {}
    @@relation_hash = {}
    class << self
        def build(filename)
            token_list = PotionTokenType.tokenize(File.readlines(filename).join(""))
            token_buffer = TokenBuffer.new(token_list)
            syntax_tree = PotionCombinatorParser.new(token_buffer).parse()
            build_to_models(syntax_tree)
        end
        def build_to_models(syntax_tree)
            syntax_tree.each do |potion|
                substance = add_substance(potion[:parent])
                add_children_or_record(substance, potion[:children])
            end
            @@obj_hash
        end
        def add_substance(name)
            substance = @@obj_hash[name]
            if not substance
                substance = Substance.new(name)
                @@obj_hash[name] = substance
                add_self_to_parent(substance)
            end
            substance
        end
        def add_children_or_record(substance, child_names)
            child_names.each do |child_name|
                if @@obj_hash[child_name]
                    substance.add_input(@@obj_hash[child_name])
                else
                    @@relation_hash[child_name] = [] if not @@relation_hash[child_name]
                    @@relation_hash[child_name].push(substance.name)
                end
            end
        end
        def add_self_to_parent(substance)
            if @@relation_hash[substance.name]
                @@relation_hash[substance.name].each do |parent|
                    @@obj_hash[parent].add_input(substance)
                end
                @@relation_hash.delete(substance.name)
            end
        end
    end
end

if __FILE__ == $0
    require "minitest/autorun"
    require "minitest/spec"
    describe PotionSemanticModelBuilder do
        it "can build" do
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
            obj_hash = PotionSemanticModelBuilder.build("potion.script")
            health_potion = obj_hash["Health Portion"]
            health_potion.get_profile
            ProfilingService.records.must_equal(["Dessicated Glass", 
                "Clarified Water", "Octopus", "Octopus Essence", "Health Portion"])

        end
    end
end



