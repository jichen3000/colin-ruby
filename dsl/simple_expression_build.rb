# this is an example to show how expression build work.
# The expression provides a fluent interface over a normal command-query API.
# To provider functions to build the sematic models.
# from DSL chapter 32.


# freeze it
require 'date'
class Event
    attr_accessor :date, :location
    attr_reader :start_time, :end_time
    def initialize(name)
        @name = name
    end
    def set_start_time(time_str)
        @start_time = gen_time(@date, time_str)
    end
    def set_end_time(time_str)
        @end_time = gen_time(@date, time_str)
    end
end
def gen_time(date, time_str)
    Time.new(date.year, date.month, date.day, *time_str.split(":"))
end
class Calendar
    def initialize
        @events = []
    end
    def add_event(event)
        @events.push(event)
    end
    def last_event
        @events.last
    end
end

class CalendarBuilder
    def initialize
        @content = Calendar.new
    end

    def add(name)
        @content.add_event(Event.new(name))
        self
    end
    def on(year, month, day)
        @content.last_event.date=Date.new(year, month, day)
        self
    end
    def from(time_str)
        @content.last_event.set_start_time(time_str)
        self
    end
    def to(time_str)
        @content.last_event.set_end_time(time_str)
        self
    end
    def at(location)
        @content.last_event.location = location
        self
    end
    def get_content()
        @content.freeze
        @content.add_event(Event.new("123"))
        @content
    end
end

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
#         ;
p builder.get_content();
