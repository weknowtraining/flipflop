module FlipFlop
  module ControllerFilters

    extend ActiveSupport::Concern

    module ClassMethods

      def require_feature key, options = {}
        before_filter options do
          flipflop_feature_disabled key unless FlipFlop.on? key
        end
      end

    end

    def flipflop_feature_disabled key
      raise FlipFlop::Forbidden.new(key)
    end

  end
end
