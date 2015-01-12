class Chromosome
    attr_accessor :bit_string
    def initialize(length, bit=nil)
        bit ||= rand(2**length-1)
        @bit_string ||= bit.to_s(2).rjust(length,'0')
    end
    def inspect()
        "@bit_string: #{@bit_string}, "+
            "fitness: #{fitness}"
    end
    def fitness()
        Chromosome.fitness(@bit_string.to_i(2))
    end
    def bit()
        @bit_string.to_i(2)
    end
    def cross(the_mate)
        cp = crossover_pos = rand(@bit_string.length-1)+1
        the_mate.bit_string[cp..-1], @bit_string[cp..-1] = 
            @bit_string[cp..-1], the_mate.bit_string[cp..-1]
        [self, the_mate]
    end
    def to_a()
        [@bit_string.length, bit]
    end
    def self.fitness(n)
        n^0b1010
    end
end

class ChromosomePool
    attr_accessor :items
    def initialize(length, random_number:nil, bit_arr:nil, items:nil)
        if random_number
            @items = Array.new(random_number) {Chromosome.new(length)}
        end
        if bit_arr
            @items = bit_arr.map {|bit| Chromosome.new(length, bit)}
        end
        if items
            @items = items
        end
    end
    def produce_new()
        wheel = roulette_wheel()
        @items = @items.map{|item| wheel.sample()}
        self
    end
    def roulette_wheel()
        @items.map{|item| [item]*item.fitness}.flatten()
    end
    def cal_mate_hash()
        indexes = []
        @items.each_index{|i| indexes<<i}
        Hash[*indexes]
    end
    def cross()
        mate_hash = cal_mate_hash()
        mate_hash.map do |key, value|
            @items[key].cross(@items[value])
        end
        self
    end
    def inspect
        @items.map{|item| item.inspect}.join("\n")
    end
    def to_a
        @items.map{|item| item.to_a}
    end
end

def main(count)
    pool = ChromosomePool.new(8, random_number:8)
    count.times do 
        pool.produce_new().cross()
    end
    pool
end

if __FILE__ == $0
    require 'minitest/spec'
    require 'minitest/autorun'
    require 'testhelper'

    main(1000).pt()

    describe Chromosome do
        before do
            @arr = []
        end
        it "initialize" do
            c = Chromosome.new(5)
            c.bit_string.length.must_equal(5)

            c = Chromosome.new(5, 6)
            c.bit_string.must_equal("00110")
        end
        it "cross" do
            c = Chromosome.new(5, 0)
            the_mate = Chromosome.new(5, 31)
            # it will fix the return value of rand
            srand(1)
            c.cross(the_mate).map(&:bit_string).must_equal(
                ["00111", "11000"])
        end

    end
    describe ChromosomePool do
        it "initialize" do
            pool = ChromosomePool.new(5,bit_arr:[12,13,14])
            pool.to_a.must_equal([[5,12],[5,13], [5,14]])
            pool = ChromosomePool.new(5,random_number:3)
            pool.items.length.must_equal(3)
        end
        it "roulette_wheel" do
            pool = ChromosomePool.new(5,bit_arr:[12,13,14])
            pool.roulette_wheel.length.must_equal(17)
        end
        it "cal_mate_hash" do
            pool = ChromosomePool.new(5,bit_arr:[12,13,14,15])
            pool.cal_mate_hash.must_equal({0=>1, 2=>3})
        end
        it "cross" do
            srand(1)
            pool = ChromosomePool.new(5,bit_arr:[12,13,0,31])
            pool.cross().items.map(&:bit_string).must_equal(
                ["01101", "01100", "00001", "11110"])
        end
    end
end