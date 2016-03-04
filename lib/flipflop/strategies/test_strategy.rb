module Flipflop
  module Strategies
    class TestStrategy < AbstractStrategy
      def initialize(**options)
        super
        @features = {}
      end

      def switchable?
        true
      end

      def knows?(feature)
        @features.has_key?(feature)
      end

      def enabled?(feature)
        @features[feature]
      end

      def switch!(feature, enabled)
        @features[feature] = enabled
      end

      def clear!(feature)
        @features.delete(feature)
      end

      def reset!
        @features.clear
      end
    end
  end
end
