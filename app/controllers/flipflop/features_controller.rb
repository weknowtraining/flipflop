require "bootstrap"

module Flipflop
  class FeaturesController < ApplicationController
    layout "flipflop"

    def index
      @feature_set = FeaturesPresenter.new(FeatureSet.current)
    end

    class FeaturesPresenter
      include Flipflop::Engine.routes.url_helpers

      extend Forwardable
      delegate [:features, :strategies] => :@feature_set

      def initialize(feature_set)
        @feature_set = feature_set
      end

      def status(feature)
        @feature_set.enabled?(feature.key) ? "on" : "off"
      end

      def strategy_status(strategy, feature)
        if strategy.knows?(feature.key)
          strategy.enabled?(feature.key) ? "on" : "off"
        end
      end

      def switch_url(strategy, feature)
        feature_strategy_path(feature.key, strategy.key)
      end
    end
  end
end
