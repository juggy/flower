require 'rspec'
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'flower'))

RSpec.configure do |config|
  config.before(:each) do
    Typhoeus::Hydra.allow_net_connect = false
  end
end
