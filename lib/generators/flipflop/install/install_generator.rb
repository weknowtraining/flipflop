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
    comment = <<-RUBY
# Replace with a lambda or method name defined in ApplicationController
# to implement access control for the Flipflop dashboard.
RUBY

    forbidden = <<-RUBY
config.flipflop.dashboard_access_filter = -> { head :forbidden }
RUBY

    allowed = <<-RUBY
config.flipflop.dashboard_access_filter = nil
RUBY

    environment(indent(comment + forbidden + "\n", 4).lstrip)
    environment(indent(comment + allowed + "\n", 2).lstrip, env: [:development, :test])
  end

  private

  def indent(content, multiplier = 2)
    spaces = " " * multiplier
    content.each_line.map {|line| line.blank? ? line : "#{spaces}#{line}" }.join
  end
end
