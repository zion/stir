module CoreExt
  module String
    def interpolate(h)
      return self if h.nil?
      self.gsub(/%({\w+})/) do |match|
        return self if match.nil?
        key = $1.tr('{}', '').to_sym
        raise KeyError.new("key{#{key}} not found") unless h.has_key?(key)
        CGI::escape(h[key])
      end
    end
  end
end