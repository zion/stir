module Stir
  class SoapClient < Stir::Base::Client
    include Stir::Operations
    include Stir::SoapConfiguration

    def self.inherited(subclass)
      set_default_options_for(subclass)
    end

    def initialize
      super
      define_operations!
    end

  end
end
