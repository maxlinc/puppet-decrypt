# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'puppet/face'

MINIMUM_IV_LENGTH = 20
describe Puppet::Face[:crypt, :current] do
  let(:insecure_opts) do
    {:salt => '1234567890'}
  end
  before :all do
    mock_secret_key(Puppet::Decrypt::Decryptor::DEFAULT_FILE, 'masterkey')
  end

  describe 'encrypt' do
    describe 'should encrypt a value' do
      it 'is decryptable with minimum args' do
        encrypted = subject.encrypt('flabberghaster')
        subject.decrypt(encrypted).should == 'flabberghaster'
      end
      it 'with ENC[...]' do
        subject.encrypt('flabberghaster', insecure_opts).should == 'ENC[KPQvuDjlC+LBmd07S/kyckDO0gDBZ1VZDuWOckmpX9Q=:1234567890]'
      end

      it 'with --raw' do
        subject.encrypt('flabberghaster', {:raw => true}.merge(insecure_opts)).should == 'KPQvuDjlC+LBmd07S/kyckDO0gDBZ1VZDuWOckmpX9Q=:1234567890'
      end

      it 'with --secretkey' do
        mock_secret_key('/etc/another_key', 'anotherkey')
        subject.encrypt('flabberghaster', {:secretkey => '/etc/another_key'}.merge(insecure_opts)).should == 'ENC[q5+72OWXTsycu43GcJ16vaMCtAMeWhrLofBTeabsmt8=:1234567890]'
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