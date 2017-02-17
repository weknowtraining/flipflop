require "bundler/setup"
require "flipflop"

gem "minitest"
require "minitest/autorun"

require "action_controller"

# Who is setting this to true? :o
$VERBOSE = false

def create_request
  env = Rack::MockRequest.env_for("/example")
  request = ActionDispatch::TestRequest.new(env)
  request.host = "example.com"

  class << request
    def cookie_jar
      @cookie_jar ||= begin
        method = ActionDispatch::Cookies::CookieJar.method(:build)
        if method.arity == 2 # Rails 5.0
          method.call(self, {})
        else
          method.call(self)
        end
      end
    end
  end

  request
end

def reload_constant(name)
  ActiveSupport::Dependencies.remove_constant(name.to_s)
  path = ActiveSupport::Dependencies.search_for_file(name.to_s.underscore).sub!(/\.rb\z/, "")
  ActiveSupport::Dependencies.loaded.delete(path)
  Object.const_get(name)
end

class TestApp
  class << self
    def new
      ActiveSupport::Dependencies.remove_constant("App")
      super.tap do |current|
        current.create!
        current.load!
        current.migrate!
        reload_constant("Flipflop::Feature")
      end
    end
  end

  def create!
    require "rails/generators"
    require "rails/generators/rails/app/app_generator"
    require "generators/flipflop/install/install_generator"

    FileUtils.rm_rf(File.expand_path("../../tmp/app", __FILE__))
    Dir.chdir(File.expand_path("../..", __FILE__))

    Rails::Generators::AppGenerator.new(["tmp/app"],
      quiet: true,
      api: ENV["RAILS_API_ONLY"].to_i.nonzero?,
      skip_active_job: true,
      skip_bundle: true,
      skip_gemfile: true,
      skip_git: true,
      skip_javascript: true,
      skip_keeps: true,
      skip_spring: true,
      skip_test_unit: true,
      skip_turbolinks: true,
    ).invoke_all

    Flipflop::InstallGenerator.new([],
      quiet: true,
    ).invoke_all
  end

  def load!
    ENV["RAILS_ENV"] = "test"
    require "rails"
    require "flipflop/engine"
    require File.expand_path("../../tmp/app/config/environment", __FILE__)
    ActiveSupport::Dependencies.mechanism = :load
    load(Rails.application.paths["config/features.rb"].existent.first)
    require "capybara/rails"
  end

  def migrate!
    ActiveRecord::Base.establish_connection

    silence_stdout { ActiveRecord::Tasks::DatabaseTasks.create_current }
    ActiveRecord::Migration.verbose = false
    ActiveRecord::Migrator.migrate(Rails.application.paths["db/migrate"].to_a)
  end

  def silence_stdout
    stdout, $stdout = $stdout, StringIO.new
    yield rescue nil
    $stdout = stdout
  end
end
