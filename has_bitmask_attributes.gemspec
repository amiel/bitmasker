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
    It's quite old but works well.
  }

  s.rubyforge_project = "has_bitmask_attributes"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency ""
end
