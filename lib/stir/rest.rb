require 'stir/config'

begin
  require 'httparty'
rescue ::LoadError
  raise $!, "Please add httparty (#{dependency_config['rest']}) to your Gemfile to do RESTful API testing\n", $!.backtrace
end

require 'stir/base'
require 'stir/rest/rest_configuration'
require 'stir/rest/endpoints'
require 'stir/rest/rest_client'