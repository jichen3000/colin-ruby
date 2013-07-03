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
class AtLeastCondition
    def initialize aSymbol, value
        @attribute, @value = aSymbol, value
    end
    def match anItinerary
        return anItinerary.items.any?{|i| match_item i}
    end
    def match_item anItem
        return false unless anItem.respond_to?(@attribute)
        return @value <= anItem.send(@attribute)
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
        return self
    end
    def when
        return ConditionAtributeNameBuilder.new(self)
    end


    def add_condition cond
        current_rule.add_condition cond
    end
    def current_rule
        @rules.last
    end
    def and
        return ConditionAtributeNameBuilder.new(self)
    end
end
class Builder
    attr_accessor :content, :parent
    def initialize parentBuilder = nil
        @parent = parentBuilder
    end
end

class ConditionAtributeNameBuilder < Builder
    def initialize parent
        @parent = PromotionConditionBuilder.new(parent)
        @parent.name = self
    end
    def method_missing method_id, *args
        @content = method_id.to_s
        return ConditionOperatorBuilder.new(@parent)
    end
end
class PromotionConditionBuilder < Builder
    attr_accessor :name, :operator, :value
    def end_condition
        content = @operator.build_content(@name.content, @value.content)
        @parent.add_condition content
        return @parent
    end
end
class ConditionOperatorBuilder < Builder
    attr_reader :condition_class
    def initialize parent
        super
        @parent.operator = self
    end
    def equals
        @content = EqualityCondition
        return next_builder
    end 
    def at
        return self
    end
    def least
        @content = AtLeastCondition
        return next_builder
    end
    def next_builder
        return ConditionValueBuilder.new(@parent)
    end
    def build_content name, value
        return @content.new(name, value)
    end
end
class ConditionValueBuilder < Builder
    def initialize parent
        super
        @parent.value = self
    end
    def method_missing method_id, *args
        @content = method_id.to_s
        @content = @content.to_i if @content =~ /^_\d+$/
        @parent.end_condition
    end 
end
@builder = PromotionBuilder.new
@builder.score(350).when.from.equals.BOS
@builder.score(100).when.brand.equals.hyatt
p @builder.content
i = Itinerary.new(@builder.content.rules)
i << Flight.new("BOS", "NK")
i << Hotel.new(4, 'hyatt')
p i.score_of()

# @builder.score(170).when.from.equals.BOS.and.nights.at.least._3