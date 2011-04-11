# http://blog.synatic.net/2009/3/19/commander-command-line-executables-in-ruby
# gem sources -a http://gems.github.com/
# gem i visionmedia-commander

require 'commander'

program :name, 'Foo Bar'
program :version, '1.0.0'
program :description, 'Stupid command that!'

command :foo do |c|
  c.syntax = 'foobar foo'
  c.description = 'Displays foo'
  c.when_called do |args,options|
    sav 'foo'
  end
end
