require File.expand_path("../../test_helper", __FILE__)

describe Flipflop::Declarable do
  subject do
    Class.new do
      extend Flipflop::Declarable
    end
  end

  describe "included" do
    it "should reset feature set" do
      subject.feature(:one, default: true)
      Class.new do
        extend Flipflop::Declarable
      end

      assert_equal [], Flipflop::FeatureSet.instance.features
    end
  end

  describe "feature" do
    it "should append feature definition" do
      subject.feature(:one, default: true)
      subject.feature(:two, default: false)

      assert_equal [:one, :two],
        Flipflop::FeatureSet.instance.features.map(&:key)
    end

    it "should append feature definition with default" do
      subject.feature(:one, default: true)
      subject.feature(:two, default: false)

      assert_equal [true, false],
        Flipflop::FeatureSet.instance.features.map(&:default)
    end
  end

  describe "strategy" do
    it "should append strategy classes" do
      strategies = [
        Class.new(Flipflop::AbstractStrategy),
        Class.new(Flipflop::AbstractStrategy),
      ]

      subject.strategy(strategies[0])
      subject.strategy(strategies[1])

      assert_equal strategies, Flipflop::FeatureSet.instance.strategies.map(&:class)
    end

    it "should append strategy objects" do
      strategy_class = Class.new(Flipflop::AbstractStrategy)
      strategies = [
        strategy_class.new,
        strategy_class.new,
      ]

      subject.strategy(strategies[0])
      subject.strategy(strategies[1])

      assert_equal strategies, Flipflop::FeatureSet.instance.strategies
    end

    it "should append strategy classes with options" do
      strategy_class = Class.new(Flipflop::AbstractStrategy)

      subject.strategy(strategy_class, name: "my strategy")
      subject.strategy(strategy_class, name: "awesome strategy")

      assert_equal ["my strategy", "awesome strategy"],
        Flipflop::FeatureSet.instance.strategies.map(&:name)
    end
  end
end
