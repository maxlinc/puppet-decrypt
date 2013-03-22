require 'puppet-decrypt'

module Puppet::Parser::Functions
  newfunction(:decrypt, :type => :rvalue) do |args|
    Puppet::Decrypt::Decryptor.new.decrypt(args[0])
  end
end
