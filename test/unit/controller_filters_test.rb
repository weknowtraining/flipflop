require File.expand_path("../../test_helper", __FILE__)

require "action_controller"

describe Flipflop::ControllerFilters do
  subject do
    Class.new do
      extend Flipflop::Declarable
      strategy Flipflop::TestStrategy
      feature :test
    end

    Class.new(ActionController::Metal) do
      include AbstractController::Callbacks
      include Flipflop::ControllerFilters

      def index
      end

      def show
      end
    end
  end

  describe "require_feature" do
    describe "with defaults" do
      it "should block action without feature" do
        subject.send(:require_feature, :test)
        assert_raises Flipflop::Forbidden do
          subject.action(:index).call({})
        end
      end

      it "should allow action with feature" do
        subject.send(:require_feature, :test)
        Flipflop::FeatureSet.current.strategies.first.switch!(:test, true)
        assert_equal 200, subject.action(:index).call({}).first
      end
    end

    describe "with options" do
      it "should block action without feature" do
        subject.send(:require_feature, :test, only: [:show])
        assert_raises Flipflop::Forbidden do
          subject.action(:show).call({})
        end
      end

      it "should allow action with feature" do
        subject.send(:require_feature, :test, only: [:show])
        Flipflop::FeatureSet.current.strategies.first.switch!(:test, true)
        assert_equal 200, subject.action(:show).call({}).first
      end

      it "should allow other actions without feature" do
        subject.send(:require_feature, :test, only: [:show])
        assert_equal 200, subject.action(:index).call({}).first
      end
    end
  end
end
