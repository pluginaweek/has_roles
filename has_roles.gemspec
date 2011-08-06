$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'has_roles/version'

Gem::Specification.new do |s|
  s.name              = "has_roles"
  s.version           = HasRoles::VERSION
  s.authors           = ["Aaron Pfeifer"]
  s.email             = "aaron@pluginaweek.org"
  s.homepage          = "http://www.pluginaweek.org"
  s.description       = "Demonstrates a reference implementation for handling role management in ActiveRecord"
  s.summary           = "Role management in ActiveRecord"
  s.require_paths     = ["lib"]
  s.files             = `git ls-files`.split("\n")
  s.test_files        = `git ls-files -- test/*`.split("\n")
  s.rdoc_options      = %w(--line-numbers --inline-source --title has_roles --main README.rdoc)
  s.extra_rdoc_files  = %w(README.rdoc CHANGELOG.rdoc LICENSE)
  
  s.add_dependency("enumerate_by", ">= 0.4.0")
  s.add_development_dependency("rake")
  s.add_development_dependency("plugin_test_helper", ">= 0.3.2")
end
