# -*- encoding : utf-8 -*-
require 'rspec-puppet'
require 'puppet-decrypt'

RSpec::Mocks::setup(self)

if ENV['PUPPET_DEBUG']
  Puppet::Util::Log.level = :debug
  Puppet::Util::Log.newdestination(:console)
end
