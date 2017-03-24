module Flipflop
  class StrategiesController < ApplicationController
    include ActionController::RequestForgeryProtection

    def update
      strategy.switch!(feature_key, enable?)
      redirect_to(features_url)
    end

    def destroy
      strategy.clear!(feature_key)
      redirect_to(features_url)
    end

    private

    # Modeled after ActiveModel::Type::Boolean, but only returns boolean values
    # (never nil) and checks for true values, because that's what earlier
    # versions of Flipflop did.
    ENABLE_VALUES = %w(1 on ON t T).to_set.freeze

    def enable?
      ENABLE_VALUES.include?(params[:commit])
    end

    def feature_key
      params[:feature_id].to_sym
    end

    def strategy
      FeatureSet.current.strategy(params[:id])
    end
  end
end
