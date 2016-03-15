module Stir
  class RestClient
    include Stir::Endpoints
    include Stir::RestConfiguration

    attr_reader :response

    def self.inherited(subclass)
      subclass.config_file = subclass.get_config_filepath(subclass.name.demodulize.underscore)
    end

  end
end