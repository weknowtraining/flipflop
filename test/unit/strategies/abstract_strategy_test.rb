require File.expand_path("../../../test_helper", __FILE__)

describe Flipflop::AbstractStrategy do
  after do
    Flipflop::AbstractStrategy::RequestInterceptor.request = nil
  end

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

    describe "request" do
      it "should return request" do
        Flipflop::AbstractStrategy::RequestInterceptor.request = 3
        assert_equal 3, subject.send(:request)
      end

      it "should raise if request is missing" do
        Flipflop::AbstractStrategy::RequestInterceptor.request = nil
        assert_raises RuntimeError do
          subject.send(:request)
        end
      end

      it "should raise with message if request is missing" do
        Flipflop::AbstractStrategy::RequestInterceptor.request = nil
        message = nil
        begin
          subject.send(:request)
        rescue => err
          message = err.message
        end
        assert_equal "Strategy 'abstract' required request, but was used outside request context.", message
      end

      it "should raise if request is missing in thread" do
        Flipflop::AbstractStrategy::RequestInterceptor.request = 3
        assert_raises RuntimeError do
          Thread.new { subject.send(:request) }.value
        end
      end
    end

    describe "request predicate" do
      it "should return true if request is present" do
        Flipflop::AbstractStrategy::RequestInterceptor.request = 3
        assert_equal true, subject.send(:request?)
      end

      it "should return false if request is missing" do
        Flipflop::AbstractStrategy::RequestInterceptor.request = nil
        assert_equal false, subject.send(:request?)
      end
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
