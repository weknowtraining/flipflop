require File.expand_path("../../test_helper", __FILE__)

require "capybara/dsl"

class TestApp
  class << self
    def instance
      @app ||= new.tap do |instance|
        instance.create!
        instance.load!
        instance.migrate!
      end
    end
  end

  def create!
    require "rails/generators/rails/app/app_generator"
    require "generators/flipflop/install/install_generator"

    FileUtils.rm_rf("tmp/app")

    Rails::Generators::AppGenerator.new(["tmp/app"],
      quiet: true,
      skip_active_job: true,
      skip_bundle: true,
      skip_gemfile: true,
      skip_git: true,
      skip_javascript: true,
      skip_keeps: true,
      skip_spring: true,
      skip_test_unit: true,
      skip_turbolinks: true,
    ).invoke_all

    Flipflop::InstallGenerator.new([],
      quiet: true,
    ).invoke_all
  end

  def load!
    ENV["RAILS_ENV"] = "test"
    require "rails"
    require "flipflop/engine"
    require File.expand_path("../../../tmp/app/config/environment", __FILE__)
    ActiveSupport::Dependencies.mechanism = :load
    require "capybara/rails"
  end

  def migrate!
    ActiveRecord::Migration.verbose = false
    ActiveRecord::Migrator.migrate(Rails.application.paths["db/migrate"].to_a)
  end
end

describe Flipflop do
  include Capybara::DSL

  before do
    TestApp.instance
    ActiveSupport::Dependencies.remove_constant("Feature")
    Feature
  end

  subject do
    TestApp.instance
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
      Feature.class_eval do
        feature :world_domination, description: "Try and take over the world!"
        feature :shiny_things, default: true
      end

      Capybara.current_session.driver.browser.clear_cookies
      Feature.delete_all

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
end
