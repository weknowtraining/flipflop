require File.expand_path("../../../test_helper", __FILE__)

describe Flipflop::DefaultStrategy do
  before do
    Class.new do
      extend Flipflop::Declarable

      feature :one, default: true
      feature :two
    end
  end
    
  describe "with defaults" do
    subject do
      Flipflop::DefaultStrategy.new
    end

    it "should have default name" do
      assert_equal "default", subject.name
    end

    it "should have no default description" do
      assert_equal "Uses feature default status.", subject.description
    end

    it "should not be switchable" do
      assert_equal false, subject.switchable?
    end

    it "should have unique key" do
      assert_match /^\d+$/, subject.key
    end

    describe "with explicitly defaulted feature" do
      it "should know feature" do
        assert_equal true, subject.knows?(:one)
      end

      it "should have feature enabled" do
        assert_equal true, subject.enabled?(:one)
      end
    end

    describe "with implicitly defaulted feature" do
      it "should know feature" do
        assert_equal true, subject.knows?(:two)
      end

      it "should not have feature enabled" do
        assert_equal false, subject.enabled?(:two)
      end
    end
  end
end
