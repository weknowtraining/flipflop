source "https://rubygems.org"
gemspec

if ENV["CONTINUOUS_INTEGRATION"]
  gem "bootstrap", "= 4.0.0.alpha3"
end

group :test do
  version = ENV["RAILS_VERSION"] || "master"
  if version == "master"
    gem "rails", github: "rails/rails"
  else
    gem "rails", "~> #{version}.0"
  end

  gem "sqlite3", ">= 1.3", platform: :ruby
  gem "activerecord-jdbcsqlite3-adapter", platform: :jruby
  gem "minitest", ">= 4.2"
  gem "capybara", ">= 2.6"

  if ENV["RAILS_VERSION"] == "4.0"
    gem "minitest-rails", platform: :jruby
  end
end
