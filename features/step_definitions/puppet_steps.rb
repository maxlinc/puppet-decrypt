require 'tempfile'

Given /^I have the following hiera data:$/ do |hieradata|
  hierafile = Thread.current[:hierafile]
  hierafile.write(hieradata)
  hierafile.close
end

When /^I execute this puppet manifest:$/ do |manifest|
  hierafile = Thread.current[:hierafile]
  file = Tempfile.new('test_manifest')
  begin
    file.write(manifest)
    file.close
    ENV['FACTER_HIERA_FILE'] = File.basename(hierafile, '.yaml')
    ENV['PUPPET_DECRYPT_KEYDIR'] = 'features/fixtures/secretkeys'
    @output = `puppet apply --noop #{file.path} --hiera_config=features/fixtures/hiera.yaml`
    puts @output
  ensure
    file.unlink
  end
  $?.success?
end

Then /^the output should include "([^"]*)"$/ do |content|
  @output.should include content
end