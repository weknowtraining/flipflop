require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new("test") do |test|
  test.pattern = "test/**/*_test.rb"
end

Rake::TestTask.new("test:unit") do |test|
  test.pattern = "test/unit/**/*_test.rb"
end

Rake::TestTask.new("test:integration") do |test|
  test.pattern = "test/integration/**/*_test.rb"
end

task default: :test

namespace :assets do
  stylesheets_path = "app/assets/stylesheets"
  stylesheet_file = "flipflop.css"
  stylesheet_path = stylesheets_path + "/" + stylesheet_file

  task :compile do
    require "bundler/setup"
    require "flipflop"
    require "sprockets"
    require "bootstrap"

    environment = Sprockets::Environment.new
    environment.append_path stylesheets_path
    environment.append_path Bootstrap.stylesheets_path
    environment.css_compressor = :scss
    File.write(stylesheet_path, environment[stylesheet_file])
  end

  task :clean do
    FileUtils.rm(stylesheet_path)
  end
end
