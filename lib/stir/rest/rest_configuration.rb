module Stir
  module RestConfiguration
    include Stir::Base::Configuration

    def self.included(base)
      set_default_options(base)
    end

    private

    def config_list
      [:body, :http_proxyaddr, :http_proxyport, :http_proxyuser, :http_proxypass, :limit, :query, :timeout,
       :local_host, :local_port, :base_uri, :basic_auth, :debug_output, :digest_auth, :format, :headers,
       :maintain_method_across_redirects, :no_follow, :parser, :connection_adapter, :pem, :query_string_normalizer,
       :ssl_ca_file, :ssl_ca_path]
    end

    def transform_config_for_httparty(params, args_passed_in={})
      params = params.to_hash
      params['basic_auth'].symbolize_keys! if params['basic_auth']
    #  params['debug_output'] = eval(params['debug_output']) if params['debug_output']
      params['headers'] = headers if headers
      params['headers'].merge!(args_passed_in[:headers]) if args_passed_in[:headers]
      params
    end

  end
end