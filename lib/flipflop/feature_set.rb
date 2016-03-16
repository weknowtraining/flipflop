module Flipflop
  class FeatureSet
    class << self
      @@mutex = Mutex.new

      def current
        @current or @@mutex.synchronize do
          @current ||= new
        end
      end

      def reset!
        @@mutex.synchronize do
          @current = nil
        end
      end

      private :new
    end

    def initialize
      @features = Hash.new { |_, k| raise "Feature '#{k}' unknown" }
      @strategies = Hash.new { |_, k| raise "Strategy '#{k}' unknown" }
    end

    def enabled?(feature)
      FeatureCache.current.fetch(feature) do
        matching_strategy = @strategies.each_value.find do |strategy|
          strategy.knows?(feature)
        end

        if matching_strategy
          matching_strategy.enabled?(feature)
        else
          @features[feature].default
        end
      end
    end

    def add(feature)
      @@mutex.synchronize do
        @features[feature.key] = feature
      end
    end

    def use(strategy)
      @@mutex.synchronize do
        @strategies[strategy.key] = strategy
      end
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
