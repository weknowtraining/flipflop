require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new("test" => "assets:compile") do |test|
  test.pattern = "test/**/*_test.rb"
end

Rake::TestTask.new("test:unit" => "assets:compile") do |test|
  test.pattern = "test/unit/**/*_test.rb"
end

Rake::TestTask.new("test:integration" => "assets:compile") do |test|
  test.pattern = "test/integration/**/*_test.rb"
end

task default: :test

namespace :assets do
  stylesheets_path = "app/views/flipflop/stylesheets"
  stylesheets_source_path = "src/stylesheets"
  stylesheet_file = "_flipflop.css"
  
  stylesheet_path = stylesheets_path + "/" + stylesheet_file

  task :compile => :clean do
    require "bundler/setup"
    require "flipflop"
    require "sprockets"
    require "bootstrap"

    environment = Sprockets::Environment.new
    environment.append_path stylesheets_source_path
    environment.append_path Bootstrap.stylesheets_path
    environment.css_compressor = :scss
    File.write(stylesheet_path, environment[stylesheet_file])
  end

  task :clean do
    FileUtils.rm(stylesheet_path) rescue nil
  end
end
