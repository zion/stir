require 'stir/config'

begin
  require 'savon'
rescue ::LoadError
  raise $!, "Please add savon (#{dependency_config['soap']}) to your Gemfile to do SOAP API testing\n", $!.backtrace
end

#require soap files here when ready
raise NotImplementedError.new("SOAP testing is not yet implmented.")
