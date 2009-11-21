require 'rubygems'
require 'rake/gempackagetask'

spec = Gem::Specification.new do |s|
  s.name = "ruby-cache"
  s.version = "0.3.0"
  s.summary = "Ruby/Cache is a library for caching objects based on the LRU algorithm for Ruby"
  s.author = "Yoshinori K. Okuji"
  s.email = "okuji@enbug.org"
  s.homepage = "http://www.enbug.org/"
  s.description = s.summary
  s.rubyforge_project = "N/A"
  s.has_rdoc = true
  files = Dir.glob("{lib,sample}/*")
  files << 'README.rd' << 'Manual.rd' << 'Rakefile'
  s.files = files
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_zip = true
end
