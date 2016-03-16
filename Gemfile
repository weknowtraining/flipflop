source "https://rubygems.org"
gemspec

group :test do
  case version = ENV["RAILS_VERSION"]
  when "master", nil
    gem "rails", github: "rails/rails"
  else
    gem "rails", "~> #{version}.0"
  end

  gem "sqlite3", ">= 1.3", platform: :ruby
  gem "activerecord-jdbcsqlite3-adapter", platform: :jruby
  gem "minitest", ">= 4.2"
  gem "capybara", ">= 2.6"
end
