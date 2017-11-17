$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "sipgate/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "sipgate"
  s.version     = Sipgate::VERSION
  s.authors     = ["Gilles Crofils"]
  s.email       = ["gilles@secondbureau.com"]
  s.homepage    = "https://developer.sipgate.io/"
  s.summary     = "Sipgate Interface."
  s.description = "Sipgate."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  
  s.add_dependency 'faraday', '~> 0.7.4'

  #s.add_development_dependency "rails", "~> 5.1.4"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency 'byebug'
end
