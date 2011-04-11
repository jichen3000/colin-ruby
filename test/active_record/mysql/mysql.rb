require 'activerecord'

ActiveRecord::Base.establish_connection(  
  :adapter => "mysql",  
  :host => "127.0.0.1",  
  :username => "root",
  :password => "mchzroot",
  :encoding=> 'utf8',
  :database => "redmine"
)

class Issue < ActiveRecord::Base
#  self.table_name = 'issues'
end
class Journal < ActiveRecord::Base
#  self.table_name = 'journals'
end
class JournalDetail < ActiveRecord::Base
#  self.table_name = 'journal_details'
end
class Project < ActiveRecord::Base
#  self.table_name = 'journal_details'
end

#p Issue.find(:first)
#puts Issue.find(:first).subject

#projects = Project.find(:all)
#projects.map {|item| puts item.id,item.name}

oracle_issues = Issue.find(:all,:conditions=>"project_id=21")
#oracle_issues.map{|item| puts item.description}

#file = File.new("oracle_issues.txt",'w')
#YAML.dump(oracle_issues,file)
filename = File.join(File.dirname(__FILE__),"oracle_issues.txt")
File.open(filename,'w') do |file|
  oracle_issues.each do |issue|
    file.puts "id: #{issue.id}\n"+
      "subject: #{issue.subject}\n"+
      "description:\n#{issue.description}\n"+
      "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$\n\n"
  end
end
p "ok"