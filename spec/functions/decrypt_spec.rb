# -*- encoding : utf-8 -*-
require 'spec_helper'

describe 'decrypt' do
  before(:all) do
    mock_secret_key(Puppet::Decrypt::Decryptor::DEFAULT_FILE, 'masterkey')
  end

  let(:node) { 'testhost.example.com' }
  extdata_path = File.expand_path(File.join(File.dirname(__FILE__), '../../puppet/manifests/extdata'))
  let(:pre_condition) { "$extlookup_datadir = '#{extdata_path}' $extlookup_precedence = ['common', 'env_vagrant']" }

  context "unencrypted key" do
    it { should run.with_params('blah').and_return("blah") }
  end

  context "encrypted key" do
    it "should decrypt exact matches" do
      should run.with_params('ENC[3xzy8fiXlaJqv3m+aXIJNA==]').and_return("flabberghaster")
    end

    it "should not decrypt partial matches" do
      should run.with_params('fooENC[3xzy8fiXlaJqv3m+aXIJNA==]bar').and_return('fooENC[3xzy8fiXlaJqv3m+aXIJNA==]bar')
    end
  end

  context "with secret key in string" do
    it "should decrypt exact matches" do
      mock_secret_key('/etc/puppet-decrypt/another_key', 'anotherkey')
      should run.with_params('ENC:another_key[8MaZYHPdj9IpnzcuBLlMdg==]').and_return('flabberghaster')
    end

    it "should not decrypt partial matches" do
      should run.with_params('fooENC:max[3xzy8fiXlaJqv3m+aXIJNA==]bar').and_return('fooENC:max[3xzy8fiXlaJqv3m+aXIJNA==]bar')
    end
  end

  context "with secret key file" do
    it "should decrypt exact matches" do
      mock_secret_key('/etc/another_key', 'anotherkey')
      should run.with_params({ 'value' => 'ENC[8MaZYHPdj9IpnzcuBLlMdg==]', 'secretkey' => '/etc/another_key'}).and_return('flabberghaster')
    end

    it "should override a key in the string" do
      mock_secret_key('/etc/another_key', 'anotherkey')
      should run.with_params({ 'value' => 'ENC:max[8MaZYHPdj9IpnzcuBLlMdg==]', 'secretkey' => '/etc/another_key'}).and_return('flabberghaster')
    end

    it "should not decrypt partial matches" do
      should run.with_params({ 'value' => 'fooENC[3xzy8fiXlaJqv3m+aXIJNA==]bar', 'secretkey' => '/etc/another_key'}).and_return('fooENC[3xzy8fiXlaJqv3m+aXIJNA==]bar')
    end
  end
end
