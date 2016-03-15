module Stir
  module RestConfiguration
    attr_accessor :service_config, :config_file

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      attr_accessor :config_file

      def get_config_filepath(filename)
        File.join(Stir.path, 'config', "#{File.basename(filename)}.yml")
      end
    end

    def initialize
      Stir::RestConfiguration.httparty_config_list.each { |x| self.class.send(:attr_accessor, x) }
      configure_callbacks!
      send(:config_file=, self.class.config_file)
    end

    def reload_configs!
      @service_config = load_configs(@config_file)
      @service_config[:headers] = {} if @service_config[:headers].nil?
      set_config_variables
      @service_config
    end

    def config_file=(value)
      @config_file = value
      reload_configs!
    end

    def merge_configs(args_passed_in = nil)
      args_passed_in.symbolize_keys! if args_passed_in
      params_to_send = httparty_specific_configs
      args_passed_in.each { |key, value| params_to_send[key] = value } unless args_passed_in.nil?
      transform_config_for_httparty(params_to_send, args_passed_in).symbolize_keys
    end

    private

    def httparty_specific_configs
      @service_config.slice(*Stir::RestConfiguration.httparty_config_list)
    end

    def transform_config_for_httparty(params, args_passed_in)
      args_passed_in = {} if args_passed_in.nil?
      params = params.to_hash
      params['basic_auth'].symbolize_keys! if params['basic_auth']
      params['headers'] = headers if headers
      params['headers'].merge!(args_passed_in[:headers]) if args_passed_in[:headers]
      params
    end

    def self.httparty_config_list
      [:body, :http_proxyaddr, :http_proxyport, :http_proxyuser, :http_proxypass, :limit, :query, :timeout,
       :local_host, :local_port, :base_uri, :basic_auth, :debug_output, :digest_auth, :format, :headers,
       :maintain_method_across_redirects, :no_follow, :parser, :connection_adapter, :pem, :query_string_normalizer,
       :ssl_ca_file, :ssl_ca_path]
    end

    def load_configs(filename)
      raise LoadError.new("#{filename} not found.") unless File.exists?(filename)
      YAML.load_file(filename)[Stir.version][Stir.environment].with_indifferent_access
    end

    def update_configs!(name, value)
      name = name.to_s.delete('=')
      @service_config[name] = value
      instance_variable_set("@#{name}", value)
      @service_config.reject! { |key| @service_config[key].nil? }
    end

    def set_config_variables
      httparty_specific_configs.each { |k, v| instance_variable_set("@#{k}", v) }
    end

    def callback_methods
      Stir::RestConfiguration.httparty_config_list.inject([]) do |result, element|
        result.push("#{element}=".to_sym)
      end
    end

    def configure_callbacks!
      callback_methods.each do |name|
        m = self.class.instance_method(name)
        self.class.send(:define_method, name) do |*args, &block|
          update_configs!(name, *args)
          m.bind(self).(*args, &block)
        end
      end
    end

  end
end