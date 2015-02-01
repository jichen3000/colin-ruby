require "./simple"
require "testhelper"

cal = Calculator.new()

Given(/^I have entered (\d+) into it$/) do |arg1|
    arg1.pt()
    cal.push(arg1.to_i)
end

Given(/^I have entered (\d+) again$/) do |arg1|
    cal.push(arg1.to_i)
end

When(/^I press add$/) do
    @result = cal.add()
end

Then(/^the result should be (\d+)$/) do |arg1|
    # puts result
    assert(@result == arg1.to_i)
    # assert(@result == 130)
end
        