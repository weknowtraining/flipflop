require "generators/flipflop/features/features_generator"
require "generators/flipflop/migration/migration_generator"
require "generators/flipflop/routes/routes_generator"

class Flipflop::InstallGenerator < Rails::Generators::Base
  def invoke_generators
    Flipflop::FeaturesGenerator.new([], options).invoke_all
    Flipflop::MigrationGenerator.new([], options).invoke_all
    Flipflop::RoutesGenerator.new([], options).invoke_all
  end

  def configure_dashboard
    environment <<-CONFIG
# Replace this with your own 'before_action' filter in ApplicationController
    # to implement access control for the Flipflop dashboard, or provide a
    # filter as lambda directly.
    config.flipflop.dashboard_access_filter = :require_development

CONFIG
  end
end
