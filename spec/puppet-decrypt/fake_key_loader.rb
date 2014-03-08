module Puppet
  module Decrypt
    def self.key_loader=(key_loader)
      @key_loader = key_loader
    end

    class FakeKeyLoader
      def initialize
        @secrets = {}
      end

      def add_secret(secret_key_file, secret_key)
        @secrets[secret_key_file] = secret_key
      end

      def load_key(secret_key_file)
        raise "Secret key file: #{secret_key_file} is not readable!" unless @secrets.has_key? secret_key_file
        secret_key = @secrets[secret_key_file]
      end
    end
  end
end

Puppet::Decrypt.key_loader = Puppet::Decrypt::FakeKeyLoader.new
