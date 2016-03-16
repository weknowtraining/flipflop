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

class FalseStrategy < Flipflop::AbstractStrategy
  def knows?(feature)
    true
  end

  def enabled?(feature)
    false
  end
end

describe Flipflop::FeatureSet do
  subject do
    Flipflop::FeatureSet.reset!
    Flipflop::FeatureSet.current.tap do |set|
      set.add(Flipflop::FeatureDefinition.new(:one))
    end
  end

  describe "current" do
    it "should return same instance" do
      current = subject
      assert_equal current, Flipflop::FeatureSet.current
    end

    it "should return new instance if reset" do
      current = subject
      Flipflop::FeatureSet.reset!
      refute_equal current, Flipflop::FeatureSet.current
    end
  end

  describe "enabled" do
    it "should return false by default" do
      subject.use(NullStrategy.new)
      assert_equal false, subject.enabled?(:one)
    end

    it "should return value of next true strategy if unknown" do
      subject.use(NullStrategy.new)
      subject.use(TrueStrategy.new)
      assert_equal true, subject.enabled?(:one)
    end

    it "should return value of next false strategy if unknown" do
      subject.use(NullStrategy.new)
      subject.use(FalseStrategy.new)
      assert_equal false, subject.enabled?(:one)
    end
  end
end
