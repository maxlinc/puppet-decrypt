require 'puppet-decrypt/version'
require 'puppet-decrypt/decryptor'
require 'encryptor'
require 'base64'

module Puppet
  module Decrypt
    SECRET_KEY_FILE = '/etc/encryptor_secret_key'
    ENCRYPTED_PATTERN = /^ENC\[(.*)\]$/
  end
end
