module Stir
  module Base
    module Response

      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def response(response_name, &block)
          define_method(response_name.to_sym) { |*args| instance_exec(*args, &block) }
        end
      end

    end
  end
end