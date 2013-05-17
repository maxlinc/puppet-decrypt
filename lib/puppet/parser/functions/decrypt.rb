require 'puppet-decrypt'

module Puppet::Parser::Functions
  newfunction(:decrypt, :type => :rvalue) do |args|
    options = {}
    decrypt_args = {}
    if args[0].is_a? String
      decrypt_args['value'] = args[0]
    else
      decrypt_args = args[0]
      puts "Using hash: #{decrypt_args}"
    end
    Puppet::Decrypt::Decryptor.new(options).decrypt_hash(decrypt_args)
  end
end
