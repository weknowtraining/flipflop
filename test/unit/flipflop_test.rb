require File.expand_path("../../test_helper", __FILE__)

describe Flipflop do
  before do
    Class.new do
      extend Flipflop::Declarable

      feature :one, default: true
      feature :two, default: false
    end
  end

  describe "enabled?" do
    it "returns true for enabled features" do
      assert_equal true, Flipflop.on?(:one)
    end

    it "returns false for disabled features" do
      assert_equal false, Flipflop.on?(:two)
    end
  end

  describe "reset!" do
    it "should clear features" do
      Flipflop.reset!
      assert_equal [], Flipflop::FeatureSet.instance.features
    end
  end

  describe "dynamic predicate method" do
    it "should respond to feature predicate" do
      assert Flipflop.respond_to?(:one?)
    end

    it "should not respond to incorrectly formatted predicate" do
      refute Flipflop.respond_to?(:foobar!)
    end

    it "returns true for enabled features" do
      assert_equal true, Flipflop.one?
    end

    it "returns false for disabled features" do
      assert_equal false, Flipflop.two?
    end

    it "raises error for incorrectly formatted predicate" do
      assert_raises NoMethodError do
        Flipflop.foobar!
      end
    end
  end
end
