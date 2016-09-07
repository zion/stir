module Stir
  module Endpoints

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def get(name, &block)
        endpoint(name, :get, &block)
      end

      def put(name, &block)
        endpoint(name, :put, &block)
      end

      def post(name, &block)
        endpoint(name, :post, &block)
      end

      def head(name, &block)
        endpoint(name, :head, &block)
      end

      def delete(name, &block)
        endpoint(name, :delete, &block)
      end

      private
      def endpoint(name, method, &block)
        send(:define_method, name) do |*args|
          @response = HTTParty.send(method, URI.escape(yield.interpolate(args.first)), merge_configs(args.flatten.first))
        end
      end
    end

  end
end