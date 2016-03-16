require File.expand_path("../../test_helper", __FILE__)

describe Flipflop do
  before do
    Class.new do
      extend Flipflop::Declarable

      feature :one, default: true
      feature :two, default: false
    end
  end

  describe "config" do
    before do
      Flipflop.config do
        feature :config_feature, default: true
      end
    end

    it "should add features" do
      assert_equal [:config_feature],
        Flipflop::FeatureSet.current.features.map(&:key)
    end
  end

  describe "enabled?" do
    it "should return true for enabled features" do
      assert_equal true, Flipflop.on?(:one)
    end

    it "should return false for disabled features" do
      assert_equal false, Flipflop.on?(:two)
    end

    it "should call strategy once if cached" do
      counter = Class.new(Flipflop::Strategies::AbstractStrategy) do
        attr_reader :called

        def initialize(*)
          @called = 0
        end

        def knows?(feature)
          true
        end

        def enabled?(feature)
          @called += 1
        end
      end

      Class.new do
        extend Flipflop::Declarable
        strategy counter

        feature :one, default: true
      end

      begin
        Flipflop::FeatureCache.current.enable!
        Flipflop.on?(:one)
        Flipflop.on?(:one)
        assert_equal 1, Flipflop::FeatureSet.current.strategies.first.called
      ensure
        Flipflop::FeatureCache.current.disable!
      end
    end
  end

  describe "reset!" do
    it "should clear features" do
      Flipflop.reset!
      assert_equal [], Flipflop::FeatureSet.current.features
    end
  end

  describe "dynamic predicate method" do
    it "should respond to feature predicate" do
      assert Flipflop.respond_to?(:one?)
    end

    it "should not respond to incorrectly formatted predicate" do
      refute Flipflop.respond_to?(:foobar!)
    end

    it "should return true for enabled features" do
      assert_equal true, Flipflop.one?
    end

    it "should return false for disabled features" do
      assert_equal false, Flipflop.two?
    end

    it "raises error for incorrectly formatted predicate" do
      assert_raises NoMethodError do
        Flipflop.foobar!
      end
    end
  end
end
