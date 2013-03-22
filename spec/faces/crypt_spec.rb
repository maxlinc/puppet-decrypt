# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'puppet/face'

describe Puppet::Face[:crypt, :current] do
  before :all do
    mock_secret_key(Puppet::Decrypt::Decryptor::DEFAULT_FILE, 'masterkey')
  end

  describe 'encrypt' do
    describe 'should encrypt a value' do
      it 'with ENC[...]' do
        subject.encrypt('flabberghaster').should == 'ENC[3xzy8fiXlaJqv3m+aXIJNA==]'
      end

      it 'with --raw' do
        subject.encrypt('flabberghaster', {:raw => true}).should == '3xzy8fiXlaJqv3m+aXIJNA=='
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
    end
  end
end