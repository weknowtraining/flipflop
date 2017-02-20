require "bundler/setup"
require "flipflop"

gem "minitest"
require "minitest/autorun"

require "action_controller"
require "rails/generators"

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

class TestEngineGenerator < Rails::Generators::Base
  source_root File.expand_path("../templates", __FILE__)

  def copy_engine_file
    copy_file "test_engine.rb", "lib/test_engine/test_engine.rb"
  end

  def copy_engine_features_file
    copy_file "test_engine_features.rb", "lib/test_engine/config/features.rb"
  end

  def require_engine
    environment "require 'test_engine/test_engine'"
  end
end

class TestFeaturesGenerator < Rails::Generators::Base
  source_root File.expand_path("../templates", __FILE__)

  def copy_app_features_file
    copy_file "test_app_features.rb", "config/features.rb"
  end
end

class TestApp
  class << self
    def new(generators = [])
      name = "my_test_app"
      super(name, generators).tap do |current|
        current.create!
        current.load!
        current.migrate!
        reload_constant("Flipflop::Feature")
      end
    end
  end

  attr_reader :name, :generators

  def initialize(name, generators = [])
    @name = name
    @generators = generators
  end

  def create!
    require "rails/generators/rails/app/app_generator"
    require "generators/flipflop/install/install_generator"

    FileUtils.rm_rf(File.expand_path("../../" + path, __FILE__))
    Dir.chdir(File.expand_path("../..", __FILE__))

    Rails::Generators::AppGenerator.new([path],
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

    generators.each do |generator|
      generator.new([], quiet: true, force: true).invoke_all
    end
  end

  def load!
    ENV["RAILS_ENV"] = "test"
    require "rails"
    require "flipflop/engine"

    load File.expand_path("../../#{path}/config/application.rb", __FILE__)
    load File.expand_path("../../#{path}/config/environments/test.rb", __FILE__)
    Rails.application.initialize!

    ActiveSupport::Dependencies.mechanism = :load
    require "capybara/rails"
  end

  def migrate!
    ActiveRecord::Base.establish_connection

    silence_stdout { ActiveRecord::Tasks::DatabaseTasks.create_current }
    ActiveRecord::Migration.verbose = false
    ActiveRecord::Migrator.migrate(Rails.application.paths["db/migrate"].to_a)
  end

  def unload!
    Flipflop::Strategies::AbstractStrategy::RequestInterceptor.request = nil
    Flipflop::FeatureLoader.instance_variable_set(:@current, nil)

    Rails.app_class.instance_variable_set(:@instance, nil)
    Rails.instance_variable_set(:@application, nil)

    ActiveSupport::Dependencies.remove_constant(name.camelize)
  end

  private

  def silence_stdout
    stdout, $stdout = $stdout, StringIO.new
    yield rescue nil
    $stdout = stdout
  end

  def path
    "tmp/" + name
  end
end
