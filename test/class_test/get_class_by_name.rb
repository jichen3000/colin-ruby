class Person
    TTT = 123
    class Colin
    end
end

module GA
    class Cell
    end
end

def class_from_string(str)
  str.split('::').inject(Object) do |mod, class_name|
    mod.const_get(class_name)
  end
end

if __FILE__ == $0
    require 'minitest/autorun'
    require 'minitest/spec'
    require 'testhelper'

    describe "get class from name" do
        it "const_get" do
            Object.const_get(:Person).must_equal(Person)
            Object.const_get("Person").must_equal(Person)

            Person.const_get("TTT").must_equal(123)
        end
        it "how to get internal class" do
            # Object.const_get(:Person::Colin).must_equal(Person::Colin)
            Object.const_get("Person::Colin").must_equal(Person::Colin)
            Object.const_get("Person").const_get("Colin").must_equal(Person::Colin)
            Object.const_get("GA::Cell").must_equal(GA::Cell)
            Object.const_get("GA").const_get("Cell").must_equal(GA::Cell)

        end

        it "class_from_string" do
            class_from_string("Person::Colin").must_equal(Person::Colin)
        end
    end
end