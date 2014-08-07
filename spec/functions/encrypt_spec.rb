# -*- encoding : utf-8 -*-
require 'spec_helper'

describe 'encrypt' do
  before(:all) do
    mock_secret_key(Puppet::Decrypt::Decryptor::DEFAULT_FILE, 'masterkey')
  end

  let(:node) { 'testhost.example.com' }
  extdata_path = File.expand_path(File.join(File.dirname(__FILE__),
      '../../puppet/manifests/extdata'))

  let :pre_condition do
    "$extlookup_datadir = '#{extdata_path}' $extlookup_precedence = ['common', 'env_vagrant']"
  end

  let :salt do
    'test_salt'
  end

  let :iv do
    "YS7nvbPsLP+pIJQ0waxV0w=="
  end

  context "unencrypted key" do
    it "should encrypt plain string" do
      subject.call(['blah']).should =~
          Puppet::Decrypt::Decryptor::ENCRYPTED_PATTERN
    end
  end

  context "encrypted key" do
    it "should encrypt exact matches" do
      subject.call(["flabberghaster", nil, salt, iv]).should ==
          'ENC[WnA7ezNPSZx2S01T67TCfA==:WVM3bnZiUHNMUCtwSUpRMHdheFYwdz09:dGVzdF9zYWx0]'
    end
  end

  context "with secret key file" do
    it "should encrypt exact matches" do
      mock_secret_key('/etc/another_key', 'anotherkey')
      subject.call(['value' => 'flabberghaster', 'secretkey' =>
          '/etc/another_key', 'iv' => iv, 'salt' => salt]) =~
              Puppet::Decrypt::Decryptor::ENCRYPTED_PATTERN

      _, iv_hash, salt_hash = Regexp.last_match[2].split(':')
      strict_decode64(iv_hash).should == iv
      strict_decode64(salt_hash).should == salt
    end

  end
end

# Backported for ruby 1.8.7
def strict_decode64(str)
  return Base64.strict_decode64(str) if Base64.respond_to? :strict_decode64

  if str.include?("\n")
    raise(ArgumentError,"invalid base64")
  else
    Base64.decode64(str)
  end
end
