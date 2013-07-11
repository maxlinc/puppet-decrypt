# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'puppet-decrypt/version'

Gem::Specification.new do |gem|
  gem.name          = "puppet-decrypt"
  gem.version       = Puppet::Decrypt::VERSION
  gem.authors       = ["mlincoln"]
  gem.email         = ["mlincoln@thoughtworks.com"]
  gem.description   = %q{A gem for encrypting/decrypting secret values for use with Puppet}
  gem.summary       = %q{A shared secret strategy that works with any data source}
  gem.homepage      = "https://github.com/maxlinc/puppet-decrypt"
  gem.required_ruby_version = '>= 1.9.0'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency('encryptor')
  gem.add_development_dependency('rake')
  gem.add_development_dependency('cucumber')
  gem.add_development_dependency('relish')
  gem.add_development_dependency('rspec')
  gem.add_development_dependency('rspec-puppet')
  gem.add_development_dependency('puppetlabs_spec_helper')
  gem.add_development_dependency('pry')
  gem.add_development_dependency('pry-nav')
end
