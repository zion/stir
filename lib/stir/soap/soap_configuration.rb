module Stir
  module SoapConfiguration
    include Stir::Base::Configuration

    def self.included(base)
      set_default_options(base)
    end

    private

    def config_list
      [:wsdl, :endpoint, :namespace, :proxy, :open_timeout, :read_timeout, :soap_header, :encoding,
       :basic_auth, :digest_auth, :log, :log_level, :pretty_print_xml, :wsse_auth]
    end

  end
end