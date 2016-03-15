require 'yaml'

def dependency_config
  YAML.load_file(File.expand_path('config/dependencies.yml', __dir__))
end