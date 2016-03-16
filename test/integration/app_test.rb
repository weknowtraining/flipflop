require File.expand_path("../../test_helper", __FILE__)

describe Flipflop do
  before do
    @app = TestApp.new
  end

  subject do
    @app
  end

  describe "middleware" do
    it "should include cache middleware" do
      middlewares = Rails.application.middleware.map(&:klass)
      assert_includes middlewares, Flipflop::FeatureCache::Middleware
    end
  end

  describe "module" do
    before do
      Feature.class_eval do
        feature :world_domination
      end
    end

    it "should allow querying for features" do
      assert_equal false, Flipflop.world_domination?
    end
  end
end
