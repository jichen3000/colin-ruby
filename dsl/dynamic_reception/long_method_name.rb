# from DSL chapter 41

class Itinerary
    def initialize rules
        @items = []
        @rules = rules
    end
    def << arg
        @items << arg
    end
    def items
        return @items.dup
    end

    def score_of
        return @rules.inject(0) {|sum, r| sum += r.score_of(self)}
    end
end
Flight = Struct.new(:from, :to, :airline)
Hotel = Struct.new(:nights, :brand)
Promotion = Struct.new(:rules)


class PromotionRule
    def initialize anInteger
        @score = anInteger
        @conditions = []
    end
    def add_condition aPromotionCondition
        @conditions << aPromotionCondition
    end
    def score_of anItinerary
        return (@conditions.all?{|c| c.match(anItinerary)}) ? @score : 0
    end
end
class BlockCondition
    def initialize aBlock
        @block = aBlock
    end
    def match anItinerary
        @block.call(anItinerary)
    end 
end
class EqualityCondition
    def initialize aSymbol, value
        @attribute, @value = aSymbol, value
    end
    def match anItinerary
        return anItinerary.items.any?{|i| match_item i}
    end
    def match_item anItem
        return false unless anItem.respond_to?(@attribute)
        return @value == anItem.send(@attribute)
    end
end
class PromotionBuilder
    def initialize 
        @rules = []
    end
    def content
        return Promotion.new(@rules)
    end
    def score anInteger
        @rules << PromotionRule.new(anInteger)
        return PromotionConditionBuilder.new(self)
    end
    def add_condition aPromotionCondition
        @rules.last.add_condition(aPromotionCondition)
    end
end

class PromotionConditionBuilder
    def initialize parent
        @parent = parent
    end
    def method_missing(method_id, *args)
        if match = /^when_(\w*)/.match(method_id.to_s)
            process_when match.captures.last, *args
        else
            super 
        end
    end
    def process_when method_tail, *args
        attribute_names = method_tail.split('_and_')
        check_number_of_attributes(attribute_names, args)
        populate_rules(attribute_names, args)
    end
    def check_number_of_attributes(names, values)
        unless names.size == values.size
            throw "There are %d attribute names but %d arguments" %
            [names.size, values.size]
        end
    end
    def populate_rules names, args
        names.zip(args).each do |name, value|
            @parent.add_condition(EqualityCondition.new(name, value))
        end
    end
end
@builder = PromotionBuilder.new
@builder.score(300).when_from("BOS")
i = Itinerary.new(@builder.content.rules)
i << Flight.new("BOS", "NK")
p i.score_of()

p @builder.content
@builder = PromotionBuilder.new
@builder.score(350).when_from("BOS")
@builder.score(100).when_brand("hyatt")
p @builder.content
@builder = PromotionBuilder.new
@builder.score(140).when_from_and_airline("BOS","NW")
p @builder.content