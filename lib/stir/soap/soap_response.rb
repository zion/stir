require 'savon/response'

module Savon
  class Response

    def code
      self.http.code.to_i
    end

    def headers
      self.http.headers
    end

    protected

    def method_missing(name, *args, &block)
      self.body[args.first]
    end

  end
end

