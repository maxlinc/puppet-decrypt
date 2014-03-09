# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'puppet/face'

MINIMUM_IV_LENGTH = 20
describe Puppet::Face[:crypt, :current] do
  let(:insecure_opts) do
    { :salt => '1234567890', :iv => '5'*20 }
  end
  # Values above, encoded
  let(:base64_salt) { 'MTIzNDU2Nzg5MA==' }
  let(:base64_iv)   { 'NTU1NTU1NTU1NTU1NTU1NTU1NTU=' }
  before :all do
    mock_secret_key(Puppet::Decrypt::Decryptor::DEFAULT_FILE, 'masterkey')
  end

  describe 'encrypt' do
    describe 'should encrypt a value' do
      it 'is decryptable with minimum args' do
        encrypted = subject.encrypt('flabberghaster')
        subject.decrypt(encrypted).should == 'flabberghaster'
      end
      it 'is decryptable with minimum args with a salt' do
        salt = SecureRandom.base64
        encrypted = subject.encrypt('flabberghaster', {:salt => salt})
        subject.decrypt(encrypted).should == 'flabberghaster'
      end
      it 'is decryptable with problematic salt (regexp chars)' do
        salt = 'R8STny+9cq03ujQGiKDd9w=='
        encrypted = subject.encrypt('flabberghaster', {:salt => salt})
        subject.decrypt(encrypted).should == 'flabberghaster'
      end
      it 'with ENC[...]' do
        expected_value = "ENC[7u523Z+PpqSm58+BeiN4qw==:#{base64_iv}:#{base64_salt}]"
        subject.encrypt('flabberghaster', insecure_opts).should == expected_value 
      end

      it 'with --raw' do
        expected_value = "7u523Z+PpqSm58+BeiN4qw==:#{base64_iv}:#{base64_salt}"
        subject.encrypt('flabberghaster', {:raw => true}.merge(insecure_opts)).should == expected_value
      end

      it 'with --secretkey' do
        mock_secret_key('/etc/another_key', 'anotherkey')
        expected_value = "ENC[81crlXmuzSnld3+4YUkQYg==:#{base64_iv}:#{base64_salt}]"
        subject.encrypt('flabberghaster', {:secretkey => '/etc/another_key'}.merge(insecure_opts)).should == expected_value
      end
    end
  end

  describe 'decrypt' do
    describe 'should decrypt a value' do
      it 'with ENC[...]' do
        subject.decrypt('ENC[3xzy8fiXlaJqv3m+aXIJNA==]').should == 'flabberghaster'
      end

      it 'with --raw' do
        subject.decrypt('3xzy8fiXlaJqv3m+aXIJNA==', {:raw => true}).should == 'flabberghaster'
      end

      it 'with --secretkey' do
        mock_secret_key('/etc/another_key', 'anotherkey')
        subject.decrypt('ENC[8MaZYHPdj9IpnzcuBLlMdg==]', {:secretkey => '/etc/another_key'}).should == 'flabberghaster'
      end
    end
  end
end