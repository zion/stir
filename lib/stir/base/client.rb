module Stir
  module Base
    class Client

      def self.set_default_options_for(subclass)
        subclass.class_eval do
          include Response
          attr_reader :response
        end
        subclass.config = { config_file: subclass.get_config_filepath(subclass.name.demodulize.underscore) }
      end

    end
  end
end