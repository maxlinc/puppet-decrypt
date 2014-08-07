require 'puppet-decrypt'

module Puppet::Parser::Functions
  newfunction(:decrypt, :type => :rvalue) do |args|
    options = {}
    decrypt_args = {}

    if args.first.is_a? String
      decrypt_args['value'], decrypt_args['secret_key'] = args
    elsif args.first.is_a? Hash
      decrypt_args = args.first
    else
      raise TypeError, "Expected String or Hash, given #{args.first.class}"
    end

    Puppet::Decrypt::Decryptor.new(options).decrypt_hash(decrypt_args)
  end
end
