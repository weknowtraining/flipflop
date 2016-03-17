require "bootstrap"

module Flipflop
  class FeaturesController < ApplicationController
    include EnvironmentFilters

    layout "flipflop"

    def index
      @feature_set = FeaturesPresenter.new(FeatureSet.current)
    end

    class FeaturesPresenter
      include Flipflop::Engine.routes.url_helpers

      def initialize(feature_set)
        @cache = {}
        @feature_set = feature_set
      end

      def strategies
        @feature_set.strategies.reject(&:hidden?)
      end

      def features
        @feature_set.features
      end

      def status(feature)
        cache(nil, feature) do
          status_to_s(@feature_set.enabled?(feature.key))
        end
      end

      def strategy_status(strategy, feature)
        cache(strategy, feature) do
          status_to_s(strategy.enabled?(feature.key))
        end
      end

      def switch_url(strategy, feature)
        feature_strategy_path(feature.key, strategy.key)
      end

      private

      def cache(strategy, feature)
        key = feature.key.to_s + (strategy ? "-" + strategy.key.to_s : "")
        return @cache[key] if @cache.has_key?(key)
        @cache[key] = yield
      end

      def status_to_s(status)
        return "on" if status == true
        return "off" if status == false
      end
    end
  end
end
