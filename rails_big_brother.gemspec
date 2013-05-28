# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails_big_brother/version'

Gem::Specification.new do |spec|
  spec.name          = "rails_big_brother"
  spec.version       = RailsBigBrother::VERSION
  spec.authors       = ["Guillaume DOTT"]
  spec.email         = ["guillaume.dott@lafourmi-immo.com"]
  spec.description   = %q{Big Brother helps you watch and log creates, updates and destroys on your models}
  spec.summary       = %q{Log creates, updates and destroys on your models}
  spec.homepage      = ""
  spec.license       = "AGPL"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
