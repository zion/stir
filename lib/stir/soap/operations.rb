module Stir
  module Operations
    def self.included(base)
      base.extend(ClassMethods)
    end

    def define_operations!
      Savon.client(self.service_config).operations.each do |op|
        self.class.send(:define_method, op) do |*args|
          client = Savon.client(self.service_config)
          client.call(op, *args)
        end
      end
    end

    def method_missing(name, *args, &block)
      client = get_client
      client.send(name, *args, &block) if client.respond_to?(name)
    end

    private

    def get_client
      Savon.client(self.service_config)
    end

    module ClassMethods
      def operation(old_name, new_name)
        binding.pry
      end
    end
  end
end
