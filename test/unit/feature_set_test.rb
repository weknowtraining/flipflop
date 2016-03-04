require File.expand_path("../../test_helper", __FILE__)

class NullStrategy < Flipflop::AbstractStrategy
  def knows?(feature)
    false
  end
end

class TrueStrategy < Flipflop::AbstractStrategy
  def knows?(feature)
    true
  end

  def enabled?(feature)
    true
  end
end

describe Flipflop::FeatureSet do
  subject do
    Flipflop::FeatureSet.reset!
    Flipflop::FeatureSet.instance.tap do |set|
      set.add(Flipflop::FeatureDefinition.new(:one))
    end
  end

  describe "instance" do
    it "returns singleton instance" do
      instance = subject
      assert_equal Flipflop::FeatureSet.instance, instance
    end

    it "returns new instance if reset" do
      instance = subject
      Flipflop::FeatureSet.reset!
      refute_equal instance, Flipflop::FeatureSet.instance
    end
  end

  describe "enabled" do
    it "should return false by default" do
      subject.use(NullStrategy.new)
      assert_equal false, subject.enabled?(:one)
    end

    it "should return value of next strategy if unknown" do
      subject.use(NullStrategy.new)
      subject.use(TrueStrategy.new)
      assert_equal true, subject.enabled?(:one)
    end
  end
end
