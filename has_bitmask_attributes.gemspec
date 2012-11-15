# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "has_bitmask_attributes/version"

Gem::Specification.new do |s|
  s.name        = "has_bitmask_attributes"
  s.version     = HasBitmaskAttributes::VERSION
  s.authors     = ["Amiel Martin"]
  s.email       = ["amiel@carnesmedia.com"]
  s.homepage    = "http://github.com/amiel/has_bitmask_attributes"
  s.summary     = %q{has_bitmask_attributes allows you to store many boolean values as one integer field in the database.}
  s.description = %q{
    has_bitmask_attributes allows you to store many boolean values as one integer field in the database.
  }

  s.files = Dir["{lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.require_paths = ["lib"]

  s.add_dependency 'bitmask'

  # specify any dependencies here; for example:
  s.add_development_dependency "activerecord", '~> 3.0'
  s.add_runtime_dependency "activesupport", '~> 3.0'
  # active_support requires i18n
  s.add_runtime_dependency "i18n"
end
