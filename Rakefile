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
