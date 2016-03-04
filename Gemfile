source "https://rubygems.org"
gemspec

group :test do
  case version = ENV["RAILS_VERSION"]
  when "master", nil
    gem "rails", github: "rails/rails"
  else
    gem "rails", "~> #{version}.0"
  end

  gem "sqlite3", ">= 1.3"
  gem "minitest", ">= 5.8"
  gem "capybara", ">= 2.6"
end
