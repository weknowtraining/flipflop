module Flipflop
  module Declarable
    class << self
      def extended(base)
        FeatureSet.reset!
      end
    end

    def feature(feature, *options)
      FeatureSet.current.add(Flipflop::FeatureDefinition.new(feature, *options))
    end

    def strategy(strategy, *options)
      FeatureSet.current.use(strategy.is_a?(Class) ? strategy.new(*options) : strategy)
    end
  end
end
