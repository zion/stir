module Stir
  class RestClient < Stir::Base::Client
    include Stir::Endpoints
    include Stir::RestConfiguration

    def self.inherited(subclass)
      set_default_options_for(subclass)
    end

  end
end