# Extend stdlib Struct with a factory method Struct::with_defaults
# to allow StructClasses to be defined so omitted members of new structs
# are initialized to a default instead of nil
module StructWithDefaults

  # makes a new StructClass specified by spec hash.
  # keys are member names, values are defaults when not supplied to new
  #
  # examples:
  # MyStruct = Struct.with_defaults( a: 1, b: 2, c: 'xyz' )
  # MyStruct.new       #=> #<struct MyStruct a=1, b=2, c="xyz"
  # MyStruct.new(99)   #=> #<struct MyStruct a=99, b=2, c="xyz">
  # MyStruct[-10, 3.5] #=> #<struct MyStruct a=-10, b=3.5, c="xyz">
  def with_defaults(*spec)
    new_args = []
    new_args << spec.shift if spec.size > 1
    spec = spec.first
    raise ArgumentError, "expected Hash, got #{spec.class}" unless spec.is_a? Hash
    new_args.concat spec.keys

    new(*new_args) do

      class << self
        attr_reader :defaults
      end

      def initialize(*args)
        super
        self.class.defaults.drop(args.size).each {|k,v| self[k] = v }
      end

    end.tap {|s| s.instance_variable_set(:@defaults, spec.dup.freeze) }

  end

end

Struct.extend StructWithDefaults

MyStruct = Struct.with_defaults( a: 1, b: 2, c: 'xyz' )
p MyStruct.new       #=> #<struct MyStruct a=1, b=2, c="xyz"
p MyStruct.new(99)   #=> #<struct MyStruct a=99, b=2, c="xyz">
p MyStruct[-10, 3.5] #=> #<struct MyStruct a=-10, b=3.5, c="xyz">
