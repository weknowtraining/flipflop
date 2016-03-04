require File.expand_path("../../../test_helper", __FILE__)

class ResultSet
  def initialize(key, results = [])
    @key, @results = key, results
  end

  def first_or_initialize
    @results.first or MyFeature.new(@key, false)
  end

  def first
    @results.first
  end
end

class MyFeature < Struct.new(:key, :enabled)
  class << self
    attr_accessor :results

    def where(conditions)
      results[conditions[:key].to_sym]
    end
  end

  alias_method :enabled?, :enabled

  def destroy
    MyFeature.results[key] = ResultSet.new(key)
  end

  def save!
    MyFeature.results[key] = ResultSet.new(key, [self])
  end
end

describe Flipflop::ActiveRecordStrategy do
  describe "with defaults" do
    subject do
      Flipflop::ActiveRecordStrategy.new(class: MyFeature)
    end

    it "should have default name" do
      assert_equal "active_record", subject.name
    end

    it "should have default description" do
      assert_equal "Stores features in database. Applies to all users.",
        subject.description
    end

    it "should be switchable" do
      assert_equal true, subject.switchable?
    end

    it "should have unique key" do
      assert_match /^\d+$/, subject.key
    end

    describe "with enabled feature" do
      before do
        MyFeature.results = {
          one: ResultSet.new(:one, [MyFeature.new(:one, true)]),
        }
      end

      it "should know feature" do
        assert_equal true, subject.knows?(:one)
      end

      it "should have feature enabled" do
        assert_equal true, subject.enabled?(:one)
      end

      it "should be able to switch feature off" do
        subject.switch!(:one, false)
        assert_equal false, subject.enabled?(:one)
      end

      it "should be able to clear feature" do
        subject.clear!(:one)
        assert_equal false, subject.knows?(:one)
      end
    end

    describe "with disabled feature" do
      before do
        MyFeature.results = {
          two: ResultSet.new(:two, [MyFeature.new(:two, false)]),
        }
      end

      it "should know feature" do
        assert_equal true, subject.knows?(:two)
      end

      it "should not have feature enabled" do
        assert_equal false, subject.enabled?(:two)
      end

      it "should be able to switch feature on" do
        subject.switch!(:two, true)
        assert_equal true, subject.enabled?(:two)
      end

      it "should be able to clear feature" do
        subject.clear!(:two)
        assert_equal false, subject.knows?(:two)
      end
    end

    describe "with unsaved feature" do
      before do
        MyFeature.results = {
          three: ResultSet.new(:three),
        }
      end

      it "should not know feature" do
        assert_equal false, subject.knows?(:three)
      end

      it "should be able to switch feature on" do
        subject.switch!(:three, true)
        assert_equal true, subject.enabled?(:three)
        assert_equal true, subject.knows?(:three)
      end
    end
  end
end
