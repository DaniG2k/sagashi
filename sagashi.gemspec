$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "sagashi/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "sagashi"
  s.version     = Sagashi::VERSION
  s.authors     = ["Daniele Pestilli"]
  s.email       = ["dpestilli@funnelback.com"]
  s.homepage    = "TODO"
  s.summary     = "Sagashi is a full-text search for Ruby."
  s.description = "Sagashi is a full-text search for Ruby."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.2.3"
  s.add_dependency 'ruby-stemmer'

  s.add_development_dependency 'pry'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec-rails'
end
