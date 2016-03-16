module Stir
  class SoapClient
    include Stir::SoapConfiguration
    include Stir::Response
    include Stir::Operations

    attr_reader :response

    def self.inherited(subclass)
      subclass.config_file = subclass.get_config_filepath(subclass.name.demodulize.underscore)
    end

    def initialize
      super
      define_operations!
    end

  end
end
