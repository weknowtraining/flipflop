module Flipflop
  class Engine < ::Rails::Engine
    isolate_namespace Flipflop

    initializer "flipflop.configure_precompile_assets" do
      config.assets.precompile += ["flipflop.css"]
    end

    initializer "flipflop.load_features" do
      ActiveSupport::Dependencies.load_missing_constant(Object, :Feature) rescue nil
    end

    initializer "flipflop.load_cookie_strategy" do
      ActionController::Base.send(:include, Flipflop::CookieStrategy::Loader)
    end
  end
end
