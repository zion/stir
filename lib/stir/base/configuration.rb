module Stir
  module Base
    module Configuration
      attr_accessor :service_config, :config_file
      class ConfigurationError < StandardError; end

      def self.included(base)
        base.extend(Default)
      end

      def initialize
        config_list.each { |x| self.class.send(:attr_accessor, x) }
        configure_callbacks!
        send(:config_file=, self.class.config_file)
        custom_config_initializers
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

      private

      def custom_config_initializers
      end

      def config_list
        fail(NotImplementedError, 'You must provide a list of valid configuration options')
      end

      def configs_to_send
        @service_config.slice(*config_list)
      end

      def merge_configs(args_passed_in = nil)
        args_passed_in.symbolize_keys! if args_passed_in
        params_to_send = configs_to_send
        args_passed_in.each { |key, value| params_to_send[key] = value } unless args_passed_in.nil?
        transform_config_for_httparty(params_to_send, args_passed_in).symbolize_keys
      end

      def load_configs(filename)
        raise(ConfigurationError, "#{filename} not found.") unless File.exists?(filename)
        config =  YAML.load(ERB.new(File.read(filename)).result)
        verify_configs(config)
        config[Stir.version][Stir.environment].with_indifferent_access
      end

      def verify_configs(config)
        raise(ConfigurationError, "Version: '#{Stir.version}' is not defined for this client in the config file.") unless config.has_key? Stir.version
        raise(ConfigurationError, "Environment: '#{Stir.environment}' is not defined for Version: '#{Stir.version}' in the config file.") unless config[Stir.version].has_key? Stir.environment
      end

      def update_configs!(name, value)
        name = name.to_s.delete('=')
        @service_config[name] = value
        instance_variable_set("@#{name}", value)
        @service_config.reject! { |key| @service_config[key].nil? }
      end

      def set_config_variables
        configs_to_send.each { |k, v| instance_variable_set("@#{k}", v) }
      end

      def callback_methods
        config_list.inject([]) do |result, element|
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


      module ClassMethods
        attr_accessor :config_file

        def get_config_filepath(filename)
          File.join(Stir.path, 'config', "#{File.basename(filename)}.yml")
        end
      end

      module Default
        def set_default_options(base)
          base.extend(ClassMethods)
        end
      end

    end
  end
end
