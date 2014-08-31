# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'travis/blink1/version'

Gem::Specification.new do |spec|
  spec.name          = "travis-blink1"
  spec.version       = Travis::Blink1::VERSION
  spec.authors       = ["ryo katsuma"]
  spec.email         = ["katsuma@gmail.com"]
  spec.summary       = %q{Simple sign by blink(1) if Travis CI is passed or not.}
  spec.description   = %q{travis-blink1 is a simple sign by blink(1). When you specify a repository travis-blink1 checks your pull request and it shows signal by Travis CI is passed or not. Of course gree sign is passed and red is not.}
  spec.homepage      = "https://github.com/katsuima/travis-blink1"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake", "~> 10.3.2"
  spec.add_development_dependency "rspec", "~> 3.0.0"
  spec.add_development_dependency "guard", "~> 2.6.1"
  spec.add_development_dependency "guard-rspec", "~> 4.3.1"
  spec.add_development_dependency "growl", "~> 1.0.3"
  spec.add_development_dependency "simplecov", "~> 0.9.0"
  spec.add_development_dependency "coveralls", "~> 0.7.1"
  spec.add_dependency "rb-blink1", "~> 0.0.7"
  spec.add_dependency "travis", "~> 1.7.1"
end
