# coding: utf-8

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/jira_update/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-jira_update'
  spec.version       = Fastlane::JiraUpdate::VERSION
  spec.author        = 'Flop Butylkin'
  spec.email         = 'flop@hackerspace.by'

  spec.summary       = 'JIRA update actions'
  spec.homepage      = "https://github.com/"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*"] + %w(README.md LICENSE)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  # Don't add a dependency to fastlane or fastlane_re
  # since this would cause a circular dependency

  spec.add_dependency 'jira-ruby', '~> 2.3.0'

  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'fastlane', '>= 2.49.0'
end
