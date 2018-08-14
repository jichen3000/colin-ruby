# https://www.sitepoint.com/a-guide-to-method-chaining/

class Speaker
    class << self

        def say(what)
            @say = what
            self
        end

        def drink(what)
            @drink = what
            self
        end

        def output
            "The speaker drinks #{@drink} and says #{@say}"
        end

    end
end
if __FILE__ == $0
    require 'minitest/autorun'
    require 'minitest/spec'
    require 'testhelper'

    describe "some" do
        it "function" do
            Speaker.say("Colin").drink("a little").output.must_equal(
                "The speaker drinks a little and says Colin"
            )
        end
    end
end
