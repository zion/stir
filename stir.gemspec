lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'stir/version'

Gem::Specification.new do |spec|
  spec.name = 'stir'
  spec.required_ruby_version = '>= 2.0.0'
  spec.version = Stir::VERSION
  spec.authors = ['Umair Chagani', 'Wallace Harwood']
  spec.email = ['umair.chagani@manheim.com', 'wallace.harwood@manheim.com']
  spec.summary = 'stir'
  spec.description = 'Service Testing in Ruby'
  spec.homepage = 'https://github.com/manheim/stir'
  spec.license = 'MIT'

  spec.files = Dir['lib/**/*']
  spec.require_paths = ['lib']

  spec.add_runtime_dependency('activesupport', '>= 4.0.0')

  spec.add_development_dependency('pry', '~> 0.10.1')
  spec.add_development_dependency('pry-nav', '~> 0.2.4')
  spec.add_development_dependency('httparty', '~> 0.13.7')
  spec.add_development_dependency('savon', '~> 2.11.1')

  spec.post_install_message = "Are you GETting what I'm POSTing?"
end
