require File.expand_path("../../test_helper", __FILE__)

require "capybara/dsl"

describe Flipflop do
  include Capybara::DSL

  before do
    @app = TestApp.new
  end

  subject do
    @app
  end

  describe "outside development and test" do
    before do
      Rails.env.stub(:test?, false) do
        visit "/flipflop"
      end
    end

    it "should be forbidden" do
      assert_equal 403, page.status_code
    end
  end

  describe "without features" do
    before do
      visit "/flipflop"
    end

    it "should show feature table with header" do
      assert_equal ["Cookie", "Active record", "Default"],
        all("thead th").map(&:text)[3..-1]
    end

    it "should show no features" do
      assert all("tbody tr").empty?
    end
  end

  describe "with features" do
    before do
      Flipflop::FeatureSet.current.instance_variable_set(:@features, {})
      Module.new do
        extend Flipflop::Configurable
        feature :world_domination, description: "Try and take over the world!"
        feature :shiny_things, default: true
      end

      Capybara.current_session.driver.browser.clear_cookies
      Flipflop::Feature.delete_all

      visit "/flipflop"
    end

    it "should show feature rows" do
      assert_equal ["World domination", "Shiny things"],
        all("tr[data-feature] td.name").map(&:text)
    end

    it "should show feature descriptions" do
      assert_equal ["Try and take over the world!", "Shiny things."],
        all("tr[data-feature] td.description").map(&:text)
    end

    describe "with cookie strategy" do
      it "should enable feature" do
        within("tr[data-feature=world-domination] td[data-strategy=cookie]") do
          click_on "on"
        end

        within("tr[data-feature=world-domination]") do
          assert_equal "on", first("td.status").text
          assert_equal "on", first("td[data-strategy=cookie] input.active[type=submit]").value
        end
      end

      it "should disable feature" do
        within("tr[data-feature=world-domination] td[data-strategy=cookie]") do
          click_on "off"
        end

        within("tr[data-feature=world-domination]") do
          assert_equal "off", first("td.status").text
          assert_equal "off", first("td[data-strategy=cookie] input.active[type=submit]").value
        end
      end

      it "should enable and clear feature" do
        within("tr[data-feature=world-domination] td[data-strategy=cookie]") do
          click_on "on"
        end

        within("tr[data-feature=world-domination] td[data-strategy=cookie]") do
          click_on "clear"
        end

        within("tr[data-feature=world-domination]") do
          assert_equal "off", first("td.status").text
          refute has_selector?("td[data-strategy=cookie] input.active[type=submit]")
        end
      end
    end

    describe "with active record strategy" do
      it "should enable feature" do
        within("tr[data-feature=world-domination] td[data-strategy=active-record]") do
          click_on "on"
        end

        within("tr[data-feature=world-domination]") do
          assert_equal "on", first("td.status").text
          assert_equal "on", first("td[data-strategy=active-record] input.active[type=submit]").value
        end
      end

      it "should disable feature" do
        within("tr[data-feature=world-domination] td[data-strategy=active-record]") do
          click_on "off"
        end

        within("tr[data-feature=world-domination]") do
          assert_equal "off", first("td.status").text
          assert_equal "off", first("td[data-strategy=active-record] input.active[type=submit]").value
        end
      end

      it "should enable and clear feature" do
        within("tr[data-feature=world-domination] td[data-strategy=active-record]") do
          click_on "on"
        end

        within("tr[data-feature=world-domination] td[data-strategy=active-record]") do
          click_on "clear"
        end

        within("tr[data-feature=world-domination]") do
          assert_equal "off", first("td.status").text
          refute has_selector?("td[data-strategy=active-record] input.active[type=submit]")
        end
      end
    end
  end

  describe "with hidden strategy" do
    before do
      Flipflop::FeatureSet.current.instance_variable_set(:@strategies, {})
      Module.new do
        extend Flipflop::Configurable
        strategy :query_string, hidden: true
      end

      visit "/flipflop"
    end

    it "should not show hidden strategy" do
      assert_equal [], all("thead th").map(&:text)[3..-1]
    end
  end
end
