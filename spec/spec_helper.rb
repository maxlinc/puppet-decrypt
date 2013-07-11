# -*- encoding : utf-8 -*-
require 'rspec-puppet'
require 'puppet-decrypt'
require 'rspec/mocks'

module SecretKeyHelper
  def mock_secret_key(filename, secret)
    File.should_receive(:readable?).with(filename).and_return(true)
    File.should_receive(:open).with(filename).and_return(secret)
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
