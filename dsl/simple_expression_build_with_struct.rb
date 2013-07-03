# this is an example to show how expression build work.
# The expression provides a fluent interface over a normal command-query API.
# To provider functions to build the sematic models.
# from DSL chapter 32.


# freeze it
require 'date'
require 'ice_nine'
def gen_time(date, time_str)
    Time.new(date.year, date.month, date.day, *time_str.split(":"))
end
Event = Struct.new(:name, :location,:date, :start_time, :end_time)
Calendar = Struct.new(:events)
class CalendarBuilder
    def initialize
        @content = Calendar.new([])
    end

    def add(name)
        @content.events.push(Event.new(name))
        self
    end
    def on(year, month, day)
        @content.events.last.date=Date.new(year, month, day)
        self
    end
    def from(time_str)
        @content.events.last.start_time=gen_time(@content.events.last.date, time_str)
        self
    end
    def to(time_str)
        @content.events.last.end_time=gen_time(@content.events.last.date, time_str)
        self
    end
    def at(location)
        @content.events.last.location = location
        self
    end
    def get_content()
        IceNine.deep_freeze(@content)
        @content
    end
end

if __FILE__ == $0
    require 'minitest/spec'
    require 'minitest/autorun'
    describe CalendarBuilder do
        it "can build a calendar" do
        builder = CalendarBuilder.new
        builder
            .add("dsl")
                .on(2009, 11, 8)
                .from("09:00")
                .to("16:00")
                .at("Aarhus Music Hall")
            .add("Making use of Patterns")
              .on(2009, 10, 5)
              .from("14:15")
              .to("15:45")
              .at("Aarhus Music Hall")
        builder.get_content.to_s.must_equal("#<struct Calendar events=[#<struct Event name=\"dsl\", location=\"Aarhus Music Hall\", date=#<Date: 2009-11-08 ((2455144j,0s,0n),+0s,2299161j)>, start_time=2009-11-08 09:00:00 +0800, end_time=2009-11-08 16:00:00 +0800>, #<struct Event name=\"Making use of Patterns\", location=\"Aarhus Music Hall\", date=#<Date: 2009-10-05 ((2455110j,0s,0n),+0s,2299161j)>, start_time=2009-10-05 14:15:00 +0800, end_time=2009-10-05 15:45:00 +0800>]>")
        lambda {builder.add("lll")}.must_raise RuntimeError
        end
    end
end
