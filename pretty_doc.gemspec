# encoding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pretty_doc/version'

Gem::Specification.new do |s|
  s.name          = 'pretty_doc'
  s.version       = PrettyDoc::VERSION
  s.authors       = ['lyfeyaj']
  s.email         = ['lyfeyaj@gmail.com']
  s.description   = 'Pretty document empowered by markup language'
  s.summary       = 'Pretty document empowered by markup language'
  s.homepage      = 'https://github.com/lyfeyaj/pretty_doc'
  s.license       = 'MIT'

  s.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']

  s.add_dependency 'nokogiri'
  s.add_dependency 'kramdown'
  s.add_dependency 'pygments.rb'
  s.add_dependency 'compass', '~> 1.0.3'
  s.add_dependency 'bootstrap-sass', '~> 3.3.5'

  s.add_development_dependency 'bundler', ['>= 1.0.0']
  s.add_development_dependency 'rake', ['>= 0']
  s.add_development_dependency 'rspec', ['>= 3.0.0']
  s.add_development_dependency 'rspec-its', ['>= 1.0.0']
  s.add_development_dependency 'pry', ['>= 0']
end