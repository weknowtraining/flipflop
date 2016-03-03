require "spec_helper"

describe FlipFlop do

  before(:all) do
    Class.new do
      extend FlipFlop::Declarable
      strategy FlipFlop::DeclarationStrategy
      default false
      feature :one, default: true
      feature :two, default: false
    end
  end

  after(:all) do
    FlipFlop.reset
  end

  describe ".on?" do
    it "returns true for enabled features" do
      FlipFlop.on?(:one).should be true
    end
    it "returns false for disabled features" do
      FlipFlop.on?(:two).should be false
    end
  end

  describe "dynamic predicate methods" do
    its(:one?) { should be true }
    its(:two?) { should be false }
  end

end
