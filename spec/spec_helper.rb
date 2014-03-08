# -*- encoding : utf-8 -*-
require 'rspec-puppet'
require 'puppet-decrypt/fake_key_loader'
require 'puppet-decrypt'
require 'rspec/mocks'

Puppet::Decrypt.key_loader = Puppet::Decrypt::FakeKeyLoader.new

module SecretKeyHelper
  def mock_secret_key(filename, secret)
    Puppet::Decrypt.key_loader.add_secret(filename, secret)
  end
end

RSpec::Mocks::setup(self)

RSpec.configure do |c|
  c.include SecretKeyHelper
end

if ENV['PUPPET_DEBUG']
  Puppet::Util::Log.level = :debug
  Puppet::Util::Log.newdestination(:console)
end
