# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'text_file/analyzer/version'

Gem::Specification.new do |spec|
  spec.name          = 'text-file-analyzer'
  spec.version       = TextFile::Analyzer::VERSION
  spec.authors       = ['Vadym Tyemirov']
  spec.email         = ['temirov@gmail.com']
  spec.summary       = %q|Better Colors for the Web|
  spec.description   = %q|Color palette for the web for rails|
  spec.homepage      = 'http://clrs.cc'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'facter'
  spec.add_runtime_dependency 'ascii_charts'
  spec.add_runtime_dependency 'terminal-table'
  spec.add_runtime_dependency 'parallel'
  spec.add_runtime_dependency 'activesupport'
  spec.add_runtime_dependency 'ai4r'
  spec.add_runtime_dependency 'redis-queue'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake', '>= 0'
  spec.add_development_dependency 'pry-doc', '>= 0'
  spec.add_development_dependency 'rspec', '>= 0'
end
