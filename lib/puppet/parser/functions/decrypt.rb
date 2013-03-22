require 'puppet-decrypt'

module Puppet::Parser::Functions
  newfunction(:decrypt, :type => :rvalue) do |args|
    options = {}
    options[:secretkey] = args[1] if args.length > 1
    Puppet::Decrypt::Decryptor.new(options).decrypt(args[0])
  end
end
