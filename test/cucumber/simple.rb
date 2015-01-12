class Calculator
    def initialize
        @stack = []
    end
    def push(int_value)
        @stack.push(int_value)
    end
    def add()
        @stack.inject(:+)
    end
end