module Flipflop
  module Strategies
    class DefaultStrategy < AbstractStrategy
      class << self
        def default_description
          "Uses feature default status."
        end
      end

      def knows?(feature)
        true
      end

      def enabled?(feature)
        FeatureSet.instance.feature(feature).default
      end
    end
  end
end
