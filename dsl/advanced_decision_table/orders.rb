def premium_customer?(order)
    return nil if (not order) or (not order.costomer_name)
    order.costomer_name == "colin"
end
class Order
    attr_reader :costomer_name, :weight
    def initialize(costomer_name, cost, from, weight)
        @from = from
        @cost = cost
        @costomer_name = costomer_name
        @weight = weight
    end
    def priority?
        @cost > 1000
    end
    def international?
        @from != :China
    end
end
