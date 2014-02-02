module Puppet
  module Decrypt

    class Decryptor
      ENCRYPTED_PATTERN = /^ENC:?(.*)\[(.*)\]$/
      KEY_DIR = ENV['PUPPET_DECRYPT_KEYDIR'] || '/etc/puppet-decrypt'
      DEFAULT_KEY = 'encryptor_secret_key'
      DEFAULT_FILE = File.join(KEY_DIR, DEFAULT_KEY)

      def initialize(options = {})
        @raw = options[:raw] || false
      end

      def decrypt_hash(hash)
        puts "Decrypting value: #{hash['value']}, secretkey: #{hash['secretkey']}"
        decrypt(hash['value'], hash['secretkey'])
      end

      def decrypt(value, secret_key_file)
        secret_key_file ||= secret_key_for value
        secret_key_digest = digest_from secret_key_file
        if @raw
          match = true
        else
          match = value.match(ENCRYPTED_PATTERN)
          if match
            value = match[2]
          end
        end
        if match
          value = strict_decode64(value)
          value = value.decrypt(:key => secret_key_digest)
        end
        value
      end

      def encrypt(value, secret_key_file = nil)
        secret_key_file ||= secret_key_for value
        secret_key_digest = digest_from secret_key_file
        result = value.encrypt(:key => secret_key_digest)
        encrypted_value = strict_encode64(result).strip
        encrypted_value = "ENC[#{encrypted_value}]" unless @raw
        raise "Value can't be encrypted properly" unless decrypt(encrypted_value, secret_key_file) == value
        encrypted_value
      end

      private
      def secret_key_for(value)
        match = value.match(ENCRYPTED_PATTERN)
        if match
          key = match[1]
          key = DEFAULT_KEY if key.empty?
        end
        key ||= DEFAULT_KEY
        File.join(KEY_DIR, key)
      end

      def digest_from(secret_key_file)
        raise "Secret key file: #{secret_key_file} is not readable!" unless File.readable?(secret_key_file)
        secret_key = File.open(secret_key_file, &:readline).chomp
        Digest::SHA256.hexdigest(secret_key)
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
