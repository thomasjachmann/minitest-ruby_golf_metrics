# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'minitest/ruby_golf_metrics/version'

Gem::Specification.new do |spec|
  spec.name          = "minitest-ruby_golf_metrics"
  spec.version       = Minitest::RubyGolfMetrics::VERSION
  spec.authors       = ["Thomas Jachmann"]
  spec.email         = ["self@thomasjachmann.com"]
  spec.description   = %q{Provide metrics for evaluating ruby golf solutions concerning code length when running minitests.}
  spec.summary       = %q{Ruby Golf Metrics Plugin for Minitest}
  spec.homepage      = "https://github.com/thomasjachmann/minitest-ruby_golf_metrics"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "sourcify", "0.6.0.rc4"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
