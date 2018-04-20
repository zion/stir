module Stir
  module Endpoints

    def self.included(base)
      base.extend(ClassMethods)
    end

    def routes(name, *args)
      endpoints = self.class.send(:endpoints)
      endpoint = nil
      endpoints.each {|x| endpoint = x[name.to_sym] if x[name.to_sym]}
      return nil if endpoint.nil?
      base_uri + endpoint.interpolate(args.first)
    end

    private
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
      
      def patch(name, &block)
        endpoint(name, :patch, &block)
      end

      private
      def endpoint(name, method, &block)
        send(:define_method, name) do |*args|
          @response = HTTParty.send(method, URI.escape(yield.interpolate(args.first)), merge_configs(args.flatten.first))
        end
        endpoints.push({name => yield.to_s})
      end

      def endpoints
        @endpoints ||= []
      end
    end

  end
end
