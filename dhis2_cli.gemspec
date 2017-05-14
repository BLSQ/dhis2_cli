# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dhis2_cli/version'

Gem::Specification.new do |spec|
  spec.name          = 'dhis2_cli'
  spec.version       = Dhis2Cli::VERSION
  spec.authors       = ['Nicolas Germeau']
  spec.email         = ['ngermeau@bluesquare.org']

  spec.summary       = 'CLI for manipulating DHIS2 instance'
  spec.description   = 'CLI allowing to execute usefull operations on DHIS2'
  spec.homepage      = 'http://github.com/blsq/dhis2_cli'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'bin'
  spec.executables   = ['dhis2_cli']
  spec.require_paths = ['lib']

  spec.add_dependency 'thor', '~> 0.19'
  spec.add_dependency 'platform-api', '~> 1.0'

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.6'
  spec.add_development_dependency 'faker', '~> 1.6'
  spec.add_development_dependency 'byebug', '~> 9.0'
end
