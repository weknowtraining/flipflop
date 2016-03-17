module Flipflop
  class FeatureError < StandardError
    def initialize(feature, error)
      super("Feature '#{feature}' #{error}.")
    end
  end

  class StrategyError < StandardError
    def initialize(strategy, error)
      super("Strategy '#{strategy}' #{error}.")
    end
  end

  class FeatureSet
    @@lock = Monitor.new

    class << self
      def current
        @current or @@lock.synchronize { @current ||= new }
      end

      private :new
    end

    def initialize
      @features = {}
      @strategies = {}
    end

    def configure
      @@lock.synchronize do
        initialize
        Module.new do
          extend Configurable
          instance_exec(&Proc.new)
        end
        @features.freeze
        @strategies.freeze
      end
      self
    end

    def reset!
      @@lock.synchronize do
        initialize
      end
      self
    end

    def test!(strategy = Strategies::TestStrategy.new)
      @@lock.synchronize do
        @strategies = { strategy.key => strategy.freeze }.freeze
      end
      self
    end

    def add(feature)
      @@lock.synchronize do
        @features[feature.key] = feature.freeze
      end
      self
    end

    def use(strategy)
      @@lock.synchronize do
        @strategies[strategy.key] = strategy.freeze
      end
      self
    end

    def enabled?(feature)
      FeatureCache.current.fetch(feature) do
        result = @strategies.each_value.inject(nil) do |status, strategy|
          break status unless status.nil?
          strategy.enabled?(feature)
        end
        result.nil? ? feature(feature).default : result
      end
    end

    def feature(feature)
      @features.fetch(feature) do
        raise FeatureError.new(feature, "unknown")
      end
    end

    def features
      @features.values
    end

    def strategy(strategy)
      @strategies.fetch(strategy) do
        raise StrategyError.new(strategy, "unknown")
      end
    end

    def strategies
      @strategies.values
    end
  end
end
