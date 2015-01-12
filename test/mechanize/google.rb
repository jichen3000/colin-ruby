require 'rubygems'
require 'mechanize'
require 'testhelper'

a = Mechanize.new { |agent|
    agent.user_agent_alias = 'Mac Safari'
}

a.get('https://www.google.com/') do |page|
    search_result = page.form_with(:name => 'f') do |search|
        search.q = 'Hello world'
    end.submit

    search_result.links.each do |link|
        puts link.text
    end
end
