# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "bitmasker/version"

Gem::Specification.new do |s|
  s.name        = "bitmasker"
  s.version     = Bitmasker::VERSION
  s.authors     = ["Amiel Martin"]
  s.email       = ["amiel@carnesmedia.com"]
  s.homepage    = "https://github.com/amiel/bitmasker"
  s.summary     = %q{Bitmasker allows you to store many boolean values as one integer field in the database.}
  s.description = %q{
    Bitmasker allows you to store many boolean values as one integer field in the database.
  }

  s.files = Dir["{lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.require_paths = ["lib"]

  s.add_dependency 'bitmask', '~> 0.1.0'

  # specify any dependencies here; for example:
  s.add_development_dependency "activerecord", '~> 3.0'
  s.add_runtime_dependency "activesupport", '~> 3.0'
  s.add_runtime_dependency "activemodel", '~> 3.0'
  # active_support requires i18n
  s.add_runtime_dependency "i18n"
end
