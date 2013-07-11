require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'cucumber'
require 'cucumber/rake/task'

RSpec::Core::RakeTask.new(:spec)

task :default => [:spec, :integration]

Cucumber::Rake::Task.new(:integration) do |t|
  t.cucumber_opts = "features --format pretty"
end