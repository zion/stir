module CoreExt
	module String
		def interpolate!(h)
    		self.gsub!(/%({\w+})/) { h[$1.tr('{}', '').to_sym] }
  		end
	end
end