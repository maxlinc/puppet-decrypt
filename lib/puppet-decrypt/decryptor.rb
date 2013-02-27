module Puppet
  module Decrypt
    class Decryptor
      def self.secret_key(secret_key_file = SECRET_KEY_FILE)
        raise "Secret key file: #{Puppet::Decrypt::SECRET_KEY_FILE} is not readable!" unless File.readable? Puppet::Decrypt::SECRET_KEY_FILE
        File.open(secret_key_file, &:readline).chomp
      end

      def self.decrypt(value)
        secret_key = Puppet::Decrypt::Decryptor.secret_key
        secret_key_digest = Digest::SHA256.hexdigest(secret_key)
        if value =~ Puppet::Decrypt::ENCRYPTED_PATTERN
          value = $~[1]
          value = Base64.strict_decode64(value)
          value = value.decrypt(key: secret_key_digest)
        end
        value
      end
    end
  end
end