source "https://rubygems.org"
gemspec

group :test do
  version = ENV["RAILS_VERSION"] || "master"
  if version == "master"
    gem "rails", github: "rails/rails"
    gem "arel", github: "rails/arel"
  else
    gem "rails", "~> #{version}.0"
  end

  gem "bootstrap", "= 4.0.0.alpha6", require: false
  gem "sqlite3", ">= 1.3", platform: :ruby
  gem "fakeredis"
  gem "activerecord-jdbcsqlite3-adapter", platform: :jruby
  gem "minitest", ">= 4.2"
  gem "capybara", ">= 2.6"

  if Gem::Version.new(RUBY_VERSION) < Gem::Version.new("2.1.0")
    # Nokogiri 1.7+ requires Ruby 2.1+.
    gem "nokogiri", "< 1.7", ruby: "< 2.4"
  end

  if ENV["RAILS_VERSION"] == "4.0"
    gem "minitest-rails", platform: :jruby
  end
end
