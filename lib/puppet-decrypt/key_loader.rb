module Puppet
  module Decrypt
    class KeyLoader
      def load_key(secret_key_file)
        raise "Secret key file: #{secret_key_file} is not readable!" unless File.readable?(secret_key_file)
        secret_key = File.open(secret_key_file, &:readline).chomp
      end
    end
  end
end
