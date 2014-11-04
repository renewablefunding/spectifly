# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'spectifly/version'

Gem::Specification.new do |spec|
  spec.name          = "spectifly"
  spec.version       = Spectifly::VERSION
  spec.authors       = ["Ravi Gadad"]
  spec.email         = ["ravi@renewfund.com"]
  spec.description   = %q{
    A library for turning business entity specifications into several
    different validatable formats, and creating fixture data for testing.
  }
  spec.summary       = %q{Generate schema files from business entity YAML specs.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "builder"
  spec.add_dependency "json"
  spec.add_dependency "rake"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "simplecov"
end
