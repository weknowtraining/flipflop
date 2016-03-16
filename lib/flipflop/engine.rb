module Flipflop
  class Engine < ::Rails::Engine
    isolate_namespace Flipflop

    config.app_middleware.insert_after ActionDispatch::Callbacks,
      Flipflop::FeatureCache::Middleware

    initializer "flipflop.configure_precompile_assets" do
      config.assets.precompile += ["flipflop.css"]
    end

    initializer "flipflop.load_features" do
      ActiveSupport::Dependencies.load_missing_constant(Object, :Feature) rescue nil
    end

    initializer "flipflop.load_request_interceptor" do
      ActionController::Base.send(:include, Flipflop::AbstractStrategy::RequestInterceptor)
    end
  end
end
