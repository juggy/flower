task :spec do
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new
end

task :run do
  require File.expand_path(File.join(File.dirname(__FILE__), 'lib', 'flower'))
  Flower.new.boot!
end
