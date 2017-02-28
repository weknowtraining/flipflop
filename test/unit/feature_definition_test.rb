require File.expand_path("../../test_helper", __FILE__)

describe Flipflop::FeatureDefinition do
  describe "with defaults" do
    subject do
      Flipflop::FeatureDefinition.new(:my_key)
    end

    it "should have specified key" do
      assert_equal :my_key, subject.key
    end

    it "should have name derived from key" do
      assert_equal "my_key", subject.name
    end

    it "should have title derived from key" do
      assert_equal "My key", subject.title
    end

    it "should have no description" do
      assert_nil subject.description
    end

    it "should default to false" do
      assert_equal false, subject.default
    end

    it "should have no group" do
      assert_nil subject.group
    end
  end

  describe "with options" do
    subject do
      Flipflop::FeatureDefinition.new(:my_key,
        default: true,
        description: "Awesome feature",
        group: Flipflop::GroupDefinition.new(:my_group),
      )
    end

    it "should have specified key" do
      assert_equal :my_key, subject.key
    end

    it "should have name derived from key" do
      assert_equal "my_key", subject.name
    end

    it "should have title derived from key" do
      assert_equal "My key", subject.title
    end

    it "should have specified description" do
      assert_equal "Awesome feature", subject.description
    end

    it "should have specified default" do
      assert_equal true, subject.default
    end

    it "should have specified group" do
      assert_equal :my_group, subject.group.key
    end
  end
end
