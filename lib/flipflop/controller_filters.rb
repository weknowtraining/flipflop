module Flipflop
  class Forbidden < StandardError
    def initialize(feature)
      super("Feature '#{feature}' required")
    end
  end

  module ControllerFilters
    extend ActiveSupport::Concern

    module ClassMethods
      def require_feature(feature, **options)
        before_action(options) do
          raise Flipflop::Forbidden.new(feature) unless Flipflop.enabled?(feature)
        end
      end
    end
  end
end
