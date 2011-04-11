# 执行rake -T
# 再执行rake gem

require 'rubygems'
require 'rake/gempackagetask'
PKG_NAME = "gem-sample"
PKG_VERSION = "1.0.0"
PKG_FILE_NAME = "#{PKG_NAME}-#{PKG_VERSION}"
PKG_FILES = FileList[
  '[A-Z]*',
  'lib/**/*.rb',
  'spec/**/*.rb',
  'bin/**/*',
]
spec = Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.summary = "Just a sample gem."
  s.name = PKG_NAME
  s.version = PKG_VERSION
  s.requirements << 'none'
  s.require_path = 'lib'
  s.autorequire = 'gem-sample'
  s.executables = ['gem-sample']
  s.default_executable = 'gem-sample'
  s.author = ["sample team"]
  s.email = "sample_team@sample.com"
  s.files = PKG_FILES
  s.description = <<-EOF
    Just a gem sample.
  EOF
end
Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_zip = true
  pkg.need_tar = true
end