source 'https://rubygems.org'

# Specify your gem's dependencies in puppet-decrypt.gemspec
gemspec

# Not in the gemspec because we're testing multiple versions with appraisal.
gem 'puppet'

# Things we don't want on Travis
group :debugging do
  # just for pushing documentation, requires ruby 1.9+
  gem 'relish'
  gem 'pry'
  gem 'pry-nav'
end

