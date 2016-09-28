$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "esignlive/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "esignlive"
  s.version     = ESignLive::VERSION
  s.authors     = ["Bo Jacobson"]
  s.email       = ["boj@fair.com"]
  s.summary     = "A Ruby client for eSignLive's REST API"
  s.description = "A Ruby client for eSignLive's REST API"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.0.0"
  s.add_dependency "httparty"

  s.add_development_dependency "rspec"
end
