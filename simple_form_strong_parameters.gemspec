$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "simple_form_strong_parameters/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "simple_form_strong_parameters"
  s.version     = SimpleFormStrongParameters::VERSION
  s.authors     = ["Kasper Johansen"]
  s.email       = ["k@spernj.org"]
  s.homepage    = "https://www.github.com/kaspernj/simple_form_strong_parameters"
  s.summary     = "Automatic handeling of strong parameters with simple form."
  s.description = "Detecting inputs from simple form, saving them in a session in order to do automatic strong parameters in the controller."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", ">= 4.0.0"
  s.add_dependency "simple_form", ">= 3.0.0"
  s.add_dependency "string-cases"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "codeclimate-test-reporter"
end
