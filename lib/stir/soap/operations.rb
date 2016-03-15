module Stir
  module Operations

    def self.included(base)
      base.extend(ClassMethods)
    end

    def operations
      @operations
    end

    def call_operation(service_config, method, message)
      @client = Savon.client(service_config)
      @response = @client.call(method, message: message)
    end

    def self.set_operations(service_config)
      client = Savon.client(service_config)
      @operations = client.operations
      @operations.each do |name|
        Stir::SoapClient.send(:define_method, name) do |message|
          call_operation(service_config, name.to_sym, message)
        end
      end
    end

    module ClassMethods

      def operation(old_name, new_name)
        #this needs to run after configuration
        #alias_method new_name.to_sym, old_name.to_sym
      end
    end

  end
end
