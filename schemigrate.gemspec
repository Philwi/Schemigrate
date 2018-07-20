# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'schemigrate/version'

Gem::Specification.new do |spec|
  spec.name          = 'schemigrate'
  spec.version       = Schemigrate::VERSION
  spec.authors       = ['Philipp Winkler']
  spec.email         = ['philoc@freenet.de']

  spec.summary       = 'Support for PostgreSQL and MySQL foreign data wrappers in Rails migrations and get only the schematas from foreign databases'
  spec.description   = 'Adds methods to ActiveRecord::Migration to create foreign-data wrappers in PostgreSQL and MySQL.'
  spec.homepage      = 'https://github.com/philwi/schemigrate'
  spec.license       = 'MIT'

  #spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  #spec.bindir        = 'exe'
  #spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  #spec.require_paths = ['lib']

  spec.add_dependency 'railties', '>= 4.0.0'
  spec.add_dependency 'activerecord', '>= 4.0.0'
  spec.add_dependency 'pg'

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake'
  #spec.add_development_dependency 'rspec', '~> 3.4'
  spec.add_development_dependency 'database_cleaner'
end
