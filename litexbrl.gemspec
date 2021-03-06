# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'litexbrl/version'

Gem::Specification.new do |spec|
  spec.name          = "litexbrl"
  spec.version       = Litexbrl::VERSION
  spec.authors       = ["Takehiko Shinkura"]
  spec.email         = ["tynmarket@gmail.com"]
  spec.description   = %q{XBRL parser for Ruby}
  spec.summary       = %q{XBRL parser for Ruby}
  spec.homepage      = "https://github.com/tyn-iMarket/litexbrl"
  spec.license       = "MIT"

  spec.required_ruby_version     = ">= 2.3.0"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = "litexbrl"
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "nokogiri", "~> 1.8"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "awesome_print"
  spec.add_development_dependency "rspec_junit_formatter"
end
