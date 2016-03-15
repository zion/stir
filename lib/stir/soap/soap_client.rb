module Stir
  class SoapClient
    include Stir::Operations
    include Stir::SoapConfiguration

    attr_reader :response, :service_config

    def self.inherited(subclass)
      subclass.config_file = subclass.get_config_filepath(subclass.name.demodulize.underscore)
    end

  end
end
