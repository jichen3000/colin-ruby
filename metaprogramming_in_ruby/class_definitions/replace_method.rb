# three ways
# 1. alias
# problem add one additional method
# problem You should never load an Around Alias twice
# main issue, it is a Monkeypatching, so it can break existing code

# 2. refine
# use super to call original method

# 3. prepend, the best practice for now
# use super to call original method
# advantage: not locally like refinement

# 1. alias
class Colin1
    def initialize(index)
        @index = index
    end
    def mm
        "mm"
    end
end

class Colin1
    alias_method :old_mm, :mm
    def mm
        if @index <= 3
            old_mm
        else
            "new mm"
        end
    end
end

# 2. refine
class Colin2
    def initialize(index)
        @index = index
    end
    def mm
        "mm"
    end
end

module Colin2Refinement
    refine Colin2 do
        def mm
            if @index <= 3
                super
            else
                "new mm"
            end
        end
    end
end
using Colin2Refinement

# 3. prepend, the best practice for now
# use super to call original method
class Colin3
    def initialize(index)
        @index = index
    end
    def mm
        "mm"
    end
end
module NewMm 
    def mm
        if @index <=3
            # use super to call original method mm
            super
        else
            "new mm"
        end 
    end
end

Colin3.class_eval do
    prepend NewMm
end


if __FILE__ == $0
    require 'minitest/autorun'
    require 'minitest/spec'
    require 'testhelper'

    describe "some" do
        it "alias" do
            Colin1.new(3).mm.must_equal("mm")
            Colin1.new(5).mm.must_equal("new mm")
        end
        it "refine" do
            Colin2.new(3).mm.must_equal("mm")
            Colin2.new(5).mm.must_equal("new mm")
        end
        it "prepend" do
            Colin3.new(3).mm.must_equal("mm")
            Colin3.new(5).mm.must_equal("new mm")
        end
    end
end