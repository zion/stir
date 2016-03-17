module Stir
  module Operations
    def self.included(base)
      base.extend(ClassMethods)
    end

    def define_operations!
      @operations = operations_available? ? get_client.operations : []
      @operations.each do |op|
        next if self.methods.include?(op)
        self.class.send(:define_method, op) do |*args|
          @response = get_client.call(op, *args)
        end
      end
    end

    def operations
      return @operations unless @operations.empty?
      []
    end

    def method_missing(name, *args, &block)
      client = get_client
      client.send(name, *args, &block) if client.respond_to?(name)
    end

    private

    def operations_available?
      return true if get_client.operations rescue RuntimeError
      false
    end

    def get_client
      Savon.client(self.service_config.symbolize_keys)
    end

    module ClassMethods
      def operation(op_name, op_alias = nil)
        self.send(:define_method, op_name) { |*args| @response = get_client.call(op_name, *args) }
        self.send(:define_method, op_alias) { |*args| send(op_name, *args) } unless op_alias.nil? || op_alias.empty?
      end
    end
  end
end
