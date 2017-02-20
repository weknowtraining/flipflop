require File.expand_path("../../test_helper", __FILE__)

describe Flipflop do
  describe "without engine" do
    before do
      @app = TestApp.new
    end

    after do
      @app.unload!
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
        Flipflop::FeatureSet.current.instance_variable_set(:@features, {})
        Module.new do
          extend Flipflop::Configurable
          feature :world_domination
        end
      end

      it "should allow querying for app features" do
        assert_equal false, Flipflop.world_domination?
      end
    end
  end

  describe "with engine" do
    before do
      @app = TestApp.new([
        TestFeaturesGenerator,
        TestEngineGenerator,
      ])
    end

    after do
      @app.unload!
    end

    subject do
      @app
    end

    describe "module" do
      it "should allow querying for app features" do
        assert_equal false, Flipflop.application_feature?
      end

      it "should allow querying for engine features" do
        assert_equal false, Flipflop.engine_feature?
      end
    end
  end
end
