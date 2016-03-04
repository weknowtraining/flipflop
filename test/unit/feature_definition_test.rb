require File.expand_path("../../test_helper", __FILE__)

describe Flipflop::FeatureDefinition do
  describe "with defaults" do
    subject do
      Flipflop::FeatureDefinition.new(:my_key)
    end

    it "should have specified key" do
      assert_equal :my_key, subject.key
    end

    it "should have humanized description" do
      assert_equal "My key.", subject.description
    end

    it "should default to false" do
      assert_equal false, subject.default
    end
  end

  describe "with options" do
    subject do
      Flipflop::FeatureDefinition.new(:my_key,
        default: true,
        description: "Awesome feature",
      )
    end

    it "should have specified key" do
      assert_equal :my_key, subject.key
    end

    it "should have specified description" do
      assert_equal "Awesome feature", subject.description
    end

    it "should have specified default" do
      assert_equal true, subject.default
    end
  end
end
