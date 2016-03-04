module Flipflop
  module Declarable
    class << self
      def extended(base)
        FeatureSet.reset!
      end
    end

    def feature(feature, *options)
      FeatureSet.instance.add(Flipflop::FeatureDefinition.new(feature, *options))
    end

    def strategy(strategy, *options)
      FeatureSet.instance.use(strategy.is_a?(Class) ? strategy.new(*options) : strategy)
    end
  end
end
