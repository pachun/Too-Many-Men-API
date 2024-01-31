source "https://rubygems.org"

ruby "3.2.3"

gem "rails", "~> 7.1.3"

gem "bootsnap", require: false
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "rack-cors"
gem "tzinfo-data", platforms: %i[ windows jruby ]

# these are all present to support active admin
gem "activeadmin"
gem "devise"
gem "sassc-rails"
gem "sprockets-rails"

group :development, :test do
  gem "byebug"
  gem "factory_bot_rails"
  gem "rspec-rails", "~> 6.1.0"
  gem "debug", platforms: %i[ mri windows ]
end

group :development do
end

group :test do
  gem "shoulda-matchers", "~> 6.0"
  gem "simplecov", require: false
end
