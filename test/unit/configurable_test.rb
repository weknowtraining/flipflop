require File.expand_path("../../test_helper", __FILE__)

describe Flipflop::Configurable do
  subject do
    Flipflop::FeatureSet.current.send(:initialize)
    Module.new do
      extend Flipflop::Configurable
    end
  end

  describe "feature" do
    it "should append feature definition" do
      subject.feature(:one, default: true)
      subject.feature(:two, default: false)

      assert_equal [:one, :two],
        Flipflop::FeatureSet.current.features.map(&:key)
    end

    it "should append feature definition with default" do
      subject.feature(:one, default: true)
      subject.feature(:two, default: false)

      assert_equal [true, false],
        Flipflop::FeatureSet.current.features.map(&:default)
    end
  end

  describe "strategy" do
    it "should append strategy objects" do
      strategy_class = Class.new(Flipflop::Strategies::AbstractStrategy)
      strategies = [
        strategy_class.new,
        strategy_class.new,
      ]

      subject.strategy(strategies[0])
      subject.strategy(strategies[1])

      assert_equal strategies, Flipflop::FeatureSet.current.strategies
    end

    it "should append strategy classes" do
      strategies = [
        Class.new(Flipflop::Strategies::AbstractStrategy),
        Class.new(Flipflop::Strategies::AbstractStrategy),
      ]

      subject.strategy(strategies[0])
      subject.strategy(strategies[1])

      assert_equal strategies, Flipflop::FeatureSet.current.strategies.map(&:class)
    end

    it "should append strategy classes with options" do
      strategy_class = Class.new(Flipflop::Strategies::AbstractStrategy)

      subject.strategy(strategy_class, name: "my strategy")
      subject.strategy(strategy_class, name: "awesome strategy")

      assert_equal ["my strategy", "awesome strategy"],
        Flipflop::FeatureSet.current.strategies.map(&:name)
    end

    it "should append strategy symbols" do
      subject.strategy(:cookie)
      subject.strategy(:query_string)

      assert_equal [
        Flipflop::Strategies::CookieStrategy,
        Flipflop::Strategies::QueryStringStrategy
      ], Flipflop::FeatureSet.current.strategies.map(&:class)
    end

    it "should append strategy symbols with options" do
      subject.strategy(:cookie, name: "my strategy")
      subject.strategy(:query_string, name: "awesome strategy")

      assert_equal ["my strategy", "awesome strategy"],
        Flipflop::FeatureSet.current.strategies.map(&:name)
    end

    it "should append strategy lambda" do
      subject.strategy { |feature| "hi!" }

      assert_equal [Flipflop::Strategies::LambdaStrategy],
        Flipflop::FeatureSet.current.strategies.map(&:class)
    end

    it "should append strategy lambda with name" do
      subject.strategy(:my_strategy) { |feature| "hi!" }

      assert_equal ["my_strategy"],
        Flipflop::FeatureSet.current.strategies.map(&:name)
    end

    it "should append strategy lambda with name and options" do
      subject.strategy("my strategy", description: "awesome") { |feature| "hi!" }

      assert_equal ["awesome"],
        Flipflop::FeatureSet.current.strategies.map(&:description)
    end
  end
end
