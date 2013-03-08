module Puppet
  module Decrypt
    class Decryptor
      def self.secret_key(secret_key_file = SECRET_KEY_FILE)
        raise "Secret key file: #{Puppet::Decrypt::SECRET_KEY_FILE} is not readable!" unless File.readable? Puppet::Decrypt::SECRET_KEY_FILE
        File.open(secret_key_file, &:readline).chomp
      end

      def self.decrypt(value, raw = false)
        value = "ENC[#{value}]" if raw
        if value =~ Puppet::Decrypt::ENCRYPTED_PATTERN
          value = $~[1]
          value = strict_decode64(value)
          value = value.decrypt(:key => secret_key_digest)
        end
        value
      end

      def self.encrypt(value)
        result = value.encrypt(:key => secret_key_digest)
        encrypted_value = Base64.strict_encode64(result).strip
        raise "Value can't be encrypted properly" unless decrypt(encrypted_value, true) == value
        encrypted_value
      end

      private

        def self.secret_key_digest
          Digest::SHA256.hexdigest(secret_key)
        end
        # Backported for ruby 1.8.7 
        #
        # Decodes a strictly base64 encoded String.
        #
        # @param [String] str
        #   The strictly encoded base64 String.
        #
        # @return [String]
        #   The decoded String.
        #
        # @raise [ArgumentError]
        #   The String is incorrectly padded or contains non-alphabet characters.
        #   Note: CR or LF are also rejected.
        #
        # @note
        #   This method complies with RFC 4648.
        #
        def self.strict_decode64(str)
          return Base64.strict_decode64(str) if Base64.respond_to? :base64

          unless str.include?("\n")
            Base64.decode64(str)
          else
            raise(ArgumentError,"invalid base64")
          end
        end
    end
  end
end
