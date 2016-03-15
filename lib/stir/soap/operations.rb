module Stir
  module Operations
    def self.included(base)
      base.extend(ClassMethods)
      base.class_eval { include Response }
    end

    def call_operation(service_config, method, message)
      @client = Savon.client(service_config)
      @response = @client.call(method, message: message)
    end

    def self.create_operations_method(client)
      Stir::SoapClient.send(:define_method, "operations") do
        client.operations
      end
    end

    def self.set_operations(service_config)
      client = Savon.client(service_config)
      create_operations_method(client)
      client.operations.each do |name|
        Stir::SoapClient.send(:define_method, name) do |message|
          call_operation(service_config, name.to_sym, message)
        end
      end
    end

    module ClassMethods
      def operation(old_name, new_name)
        #this needs to run after configuration
      end
    end
  end
end
