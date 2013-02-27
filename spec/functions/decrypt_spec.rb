# -*- encoding : utf-8 -*-
require 'spec_helper'

describe 'decrypt' do
  before(:each) do
    Puppet::Decrypt::Decryptor.should_receive(:secret_key).and_return('masterkey')
  end

  let(:node) { 'testhost.example.com' }
  extdata_path = File.expand_path(File.join(File.dirname(__FILE__), '../../puppet/manifests/extdata'))
  let(:pre_condition) { "$extlookup_datadir = '#{extdata_path}' $extlookup_precedence = ['common', 'env_vagrant']" }

  context "unencrypted key" do
    it { should run.with_params('blah').and_return(
      "blah")
    }
  end

  context "encrypted key" do
    it "should decrypt exact matches" do should run.with_params('ENC[3xzy8fiXlaJqv3m+aXIJNA==]').and_return(
      "flabberghaster")
    end

    it "should not decrypt partial matches" do
      should run.with_params('fooENC[3xzy8fiXlaJqv3m+aXIJNA==]bar').and_return('fooENC[3xzy8fiXlaJqv3m+aXIJNA==]bar')
    end
  end

end
