require "thread"

module Flipflop
  class FeatureSet
    class << self
      @@mutex = Mutex.new

      def instance
        @instance or @@mutex.synchronize do
          @instance ||= new
        end
      end

      def reset!
        @@mutex.synchronize do
          @instance = nil
        end
      end

      private :new
    end

    def initialize
      @features = Hash.new { |_, k| raise "Feature '#{k}' unknown" }
      @strategies = Hash.new { |_, k| raise "Strategy '#{k}' unknown" }
    end

    def enabled?(feature)
      @strategies.each_value do |strategy|
        return strategy.enabled?(feature) if strategy.knows?(feature)
      end
      @features[feature].default
    end

    def add(feature)
      @features[feature.key] = feature
    end

    def use(strategy)
      @strategies[strategy.key] = strategy
    end

    def feature(feature)
      @features[feature]
    end

    def features
      @features.values
    end

    def strategy(strategy)
      @strategies[strategy]
    end

    def strategies
      @strategies.values
    end
  end
end
