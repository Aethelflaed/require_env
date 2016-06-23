$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "require_env/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "require_env"
  s.version     = RequireEnv::VERSION
  s.authors     = ["Geoffroy Planquart"]
  s.email       = ["geoffroy@planquart.fr"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of RequireEnv."
  s.description = "TODO: Description of RequireEnv."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.6"
end