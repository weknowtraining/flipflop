require "generators/flipflop/migration/migration_generator"
require "generators/flipflop/model/model_generator"
require "generators/flipflop/routes/routes_generator"

class Flipflop::InstallGenerator < Rails::Generators::Base
  def invoke_generators
    Flipflop::MigrationGenerator.new([], options).invoke_all
    Flipflop::ModelGenerator.new([], options).invoke_all
    Flipflop::RoutesGenerator.new([], options).invoke_all
  end
end
