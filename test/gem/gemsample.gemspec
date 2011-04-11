spec = Gem::Specification.new do |s|
  s.name = %q{gemsample}
  s.version = "1.0.2"
  s.date = %q{2009-01-06}
  s.summary = %q{Colin's gem sample.}
  s.email = %q{jichen3000@gmail.com}
  s.homepage = %q{http://www.rubyonrails.org}
  s.author = "Colin Jack"
  s.description = %q{Implements test.}
  s.has_rdoc = true
  s.rubyforge_project = ''
  s.required_ruby_version = Gem::Version::Requirement.new(">= 0")
  s.cert_chain = []
  s.files = [ "README", "lib/gem_sample.rb"]
  s.rdoc_options = ["--main", "README"]
  s.extra_rdoc_files = ["README"]
  s.add_dependency(%q<log4r>, '>=1.0.0')
  s.add_dependency(%q<ruby-oci8>, '>=1.0.0')
end