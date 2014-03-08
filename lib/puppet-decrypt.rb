require 'puppet-decrypt/version'
require 'puppet-decrypt/key_loader'
require 'puppet-decrypt/decryptor'
require 'encryptor'
require 'base64'

module Puppet
  module Decrypt
    def self.key_loader
      @key_loader ||= Puppet::Decrypt::KeyLoader.new
    end
  end
end
