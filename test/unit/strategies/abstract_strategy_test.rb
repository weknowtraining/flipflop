require File.expand_path("../../../test_helper", __FILE__)

describe Flipflop::AbstractStrategy do
  describe "with defaults" do
    subject do
      Flipflop::AbstractStrategy.new
    end

    it "should have default name" do
      assert_equal "abstract", subject.name
    end

    it "should have no default description" do
      assert_nil subject.description
    end

    it "should not be switchable" do
      assert_equal false, subject.switchable?
    end

    it "should have unique key" do
      assert_match /^\d+$/, subject.key
    end
  end

  describe "with options" do
    subject do
      Flipflop::AbstractStrategy.new(name: "strategy", description: "my strategy")
    end

    it "should have specified name" do
      assert_equal "strategy", subject.name
    end

    it "should have specified description" do
      assert_equal "my strategy", subject.description
    end
  end
end
