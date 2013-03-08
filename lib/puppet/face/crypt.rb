require 'puppet-decrypt'
require 'puppet/face'
require 'stringio'

Puppet::Face.define(:crypt, Puppet::Decrypt::VERSION) do
  copyright "Max Lincoln", 2013
  license   "TBD"

  summary "Encrypt or decrypt secret values."
  description <<-'EOT'
    This subcommand provides a command line interface to encrypt or decrypt values
    that are intended for use with the puppet decrypt function.
  EOT

  option "--raw" do
    summary  "Use raw parse/display"
    description <<-'EOT'
      Parse or display the value in raw format, instead of using ENC(...) block
    EOT
  end

  action :encrypt do
    summary 'Encrypt a secret value.'
    arguments "<plaintext_secret>"
    description <<-EOT
      This action encrypts a value using the secret key.
    EOT
    when_invoked do |plaintext_secret, options|
      output = StringIO.new
      output << "ENC[" unless options[:raw]
      output << Puppet::Decrypt::Decryptor.encrypt(plaintext_secret)
      output << "]" unless options[:raw]
      output.string
    end
  end

  action :decrypt do
    summary 'Decrypt a secret value.'
    arguments "<encrypted_secret>"
    description <<-EOT
      This action encrypts a value using the secret key.
    EOT
    when_invoked do |encrypted_secret, options|
      raw = options[:raw] ||= false
      Puppet::Decrypt::Decryptor.decrypt(encrypted_secret, raw)
    end
  end
end