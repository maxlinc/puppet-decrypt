require 'puppet-decrypt'
module Puppet::Parser::Functions
  newfunction(:decrypt, :type => :rvalue) do |args|
    Puppet::Decrypt::Decryptor.decrypt(args.first)
  end
end
