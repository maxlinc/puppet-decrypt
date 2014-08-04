# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'puppet-decrypt/version'

Gem::Specification.new do |gem|
  gem.name          = "puppet-decrypt"
  gem.version       = Puppet::Decrypt::VERSION
  gem.authors       = ["mlincoln"]
  gem.email         = ["max@devopsy.com"]
  gem.description   = %q{A gem for encrypting/decrypting secret values for use with Puppet}
  gem.summary       = %q{A shared secret strategy that works with any data source}
  gem.homepage      = "https://github.com/maxlinc/puppet-decrypt"
  gem.required_ruby_version = '>= 1.8.7'
  notice = """

Notice: The default master key location is now /etc/puppet-decrypt/encryptor_secret_key

This was done to more easily support multiple keys.  If you are upgrading from a version older than
0.1.0 you should move /etc/encryptor_secret_key to /etc/puppet-decrypt/encryptor_secret_key.

"""
  gem.post_install_message = notice

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency('encryptor', '~> 1.3')
  gem.add_development_dependency('rake')
  gem.add_development_dependency('cucumber')
  gem.add_development_dependency('rspec')
  gem.add_development_dependency('rspec-puppet')
  gem.add_development_dependency('puppetlabs_spec_helper')
end
