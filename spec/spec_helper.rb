$PROJECT_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..'))
require 'stir/all'
require 'pry'
require 'faker'

Stir.configure do |config|
  config.path = "#{$PROJECT_ROOT}/spec/examples/stir"
  config.environment = 'dev'
  config.version = 'v1'
end