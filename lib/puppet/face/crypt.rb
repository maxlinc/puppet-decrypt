require 'puppet-decrypt'
require 'puppet/face'
require 'stringio'

Puppet::Face.define(:crypt, Puppet::Decrypt::VERSION) do
  copyright "Max Lincoln", 2013
  license   "MIT; see LICENSE"

  summary "Encrypt or decrypt secret values."
  description <<-EOT
    This subcommand provides a command line interface to encrypt or decrypt values
    that are intended for use with the puppet decrypt function.
  EOT

  option "--raw" do
    summary  "Use raw parse/display"
    description <<-EOT
      Parse or display the value in raw format, instead of using ENC[...] block
    EOT
  end

  option "--secretkey SECRET_KEY_PATH" do
    summary "The path to the secret key file (default: #{Puppet::Decrypt::Decryptor::DEFAULT_FILE}"
  end

  option "--salt SALT" do
    summary "The salt to use during encryption (default is random)"
  end

  action :encrypt do
    summary 'Encrypt a secret value.'
    arguments "<plaintext_secret>"
    description <<-EOT
      This action encrypts a value using the secret key.
    EOT
    when_invoked do |plaintext_secret, options|
      salt = options.delete(:salt) || SecureRandom.uuid
      secretkey = options[:secretkey]
      Puppet::Decrypt::Decryptor.new(options).encrypt(plaintext_secret, secretkey, salt)
    end
  end

  action :decrypt do
    summary 'Decrypt a secret value.'
    arguments "<encrypted_secret>"
    description <<-EOT
      This action decrypts a value using the secret key.
    EOT
    when_invoked do |encrypted_secret, options|
      secretkey = options[:secretkey]
      Puppet::Decrypt::Decryptor.new(options).decrypt(encrypted_secret, secretkey)
    end
  end
end