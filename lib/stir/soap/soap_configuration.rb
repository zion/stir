module Stir
  module SoapConfiguration
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
      Stir::SoapConfiguration.savon_config_list.each { |x| self.class.send(:attr_accessor, x) }
      configure_callbacks!
      send(:config_file=, self.class.config_file)
    end

    def reload_configs!
      @service_config = load_configs(@config_file)
      set_config_variables
      @service_config
    end

    def config_file=(value)
      @config_file = value
      reload_configs!
    end

    private

    def savon_specific_configs
      @service_config.slice(*Stir::SoapConfiguration.savon_config_list)
    end

    def self.savon_config_list
      [ :wsdl, :endpoint, :namespace, :proxy, :open_timeout, :read_timeout, :soap_header, :encoding,
        :basic_auth, :digest_auth, :log, :log_level, :pretty_print_xml, :wsse_auth ]
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
      savon_specific_configs.each { |k, v| instance_variable_set("@#{k}", v) }
    end

    def callback_methods
      Stir::SoapConfiguration.savon_config_list.inject([]) do |result, element|
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