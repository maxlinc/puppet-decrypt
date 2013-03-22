module Puppet
  module Decrypt

    class Decryptor
      ENCRYPTED_PATTERN = /^ENC\[(.*)\]$/
      DEFAULT_FILE = '/etc/encryptor_secret_key'

      def initialize(options = {})
        @secret_file = options[:secretkey] || DEFAULT_FILE
        @raw = options[:raw] || false
      end

      def decrypt(value)
        value = "ENC[#{value}]" if @raw
        if value =~ ENCRYPTED_PATTERN
          value = $~[1]
          value = strict_decode64(value)
          value = value.decrypt(:key => secret_key_digest)
        end
        value
      end

      def encrypt(value)
        result = value.encrypt(:key => secret_key_digest)
        encrypted_value = strict_encode64(result).strip
        encrypted_value = "ENC[#{encrypted_value}]" unless @raw
        raise "Value can't be encrypted properly" unless decrypt(encrypted_value) == value
        encrypted_value
      end

      private
      def secret_key_digest
        Digest::SHA256.hexdigest(secret_key)
      end

      def secret_key
        raise "Secret key file: #{@secret_file} is not readable!" unless File.readable?(@secret_file)
        File.open(@secret_file, &:readline).chomp
      end

      # Backported for ruby 1.8.7
      def strict_decode64(str)
        return Base64.strict_decode64(str) if Base64.respond_to? :strict_decode64

        unless str.include?("\n")
          Base64.decode64(str)
        else
          raise(ArgumentError,"invalid base64")
        end
      end

      # Backported for ruby 1.8.7
      def strict_encode64(bin)
        return Base64.strict_encode64(bin) if Base64.respond_to? :strict_encode64
        Base64.encode64(bin).tr("\n",'')
      end

    end
  end
end
