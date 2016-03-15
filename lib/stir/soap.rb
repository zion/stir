require 'stir/config'

begin
  require 'savon'
rescue ::LoadError
  raise $!, "Please add savon (#{dependency_config['soap']}) to your Gemfile to do SOAP API testing\n", $!.backtrace
end

require 'stir/base'
require 'stir/soap/soap_configuration'
require 'stir/soap/operations'
require 'stir/soap/soap_client'