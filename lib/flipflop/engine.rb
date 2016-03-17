module Flipflop
  class Engine < ::Rails::Engine
    isolate_namespace Flipflop

    config.app_middleware.insert_after ActionDispatch::Callbacks,
      FeatureCache::Middleware

    config.flipflop = ActiveSupport::OrderedOptions.new

    initializer "flipflop.assets" do |app|
      config.assets.precompile += ["flipflop.css"]
    end

    initializer "flipflop.features_path" do |app|
      app.paths.add("config/features.rb")
    end

    initializer "flipflop.features_reloader" do |app|
      app.reloaders.push(reloader = feature_reloader(app))
      to_prepare do
        reloader.execute
      end
    end

    initializer "flipflop.dashboard", after: "flipflop.features_reloader" do |app|
      if action = config.flipflop.dashboard_access_filter
        to_prepare do
          Flipflop::FeaturesController.before_action(action)
          Flipflop::StrategiesController.before_action(action)
        end
      else
        warn("WARNING: You have not set `config.flipflop.dashboard_access_filter`; " +
             "the Flipflop dashboard is now always public!")
      end
    end

    initializer "flipflop.request_interceptor" do |app|
      interceptor = Strategies::AbstractStrategy::RequestInterceptor
      ActionController::Base.send(:include, interceptor)
    end

    private

    def feature_reloader(app)
      features = app.paths["config/features.rb"].existent
      ActiveSupport::FileUpdateChecker.new(features) do
        features.each { |path| load(path) }
      end
    end

    def to_prepare
      klass = defined?(ActiveSupport::Reloader) ? ActiveSupport::Reloader : ActionDispatch::Reloader
      klass.to_prepare(&Proc.new)
    end
  end
end
