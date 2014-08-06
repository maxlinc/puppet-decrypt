require 'pathname'
module Puppet
  module Decrypt
    class KeyLoader
      def load_key(secret_key_file)

        # Dot not add directory if absolute path provided
        if Pathname.new(secret_key_file).absolute?
          full_path = secret_key_file
        else
          full_path = File.join(ENV['PUPPET_DECRYPT_KEYDIR'] ||
              Puppet::Decrypt::Decryptor::KEY_DIR, secret_key_file)
        end

        # Assume key file is specified as basename
        if File.readable? full_path
          secret_key_file = full_path
        else
          # Assume key file is specifed as full path
          raise "Secret key file: #{secret_key_file} is not readable!" unless
              File.readable? secret_key_file
        end

        File.open(secret_key_file, &:readline).chomp
      end
    end
  end
end
