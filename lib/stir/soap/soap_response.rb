require 'savon/response'

module Savon
  class Response

    protected

    def method_missing(name, *args, &block)
        self.body[args.first]
    end

  end
end

