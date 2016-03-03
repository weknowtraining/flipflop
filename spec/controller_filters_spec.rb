require "spec_helper"

class ControllerWithFlipFlopFilters
  include FlipFlop::ControllerFilters
end

describe ControllerWithFlipFlopFilters do

  describe ".require_feature" do

    it "adds before_filter without options" do
      ControllerWithFlipFlopFilters.tap do |klass|
        klass.should_receive(:before_filter).with({})
        klass.send(:require_feature, :testable)
      end
    end

    it "adds before_filter with options" do
      ControllerWithFlipFlopFilters.tap do |klass|
        klass.should_receive(:before_filter).with({ only: [ :show ] })
        klass.send(:require_feature, :testable, only: [ :show ])
      end
    end

  end

end
