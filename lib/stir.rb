$LOAD_PATH << File.dirname(__FILE__)
raise LoadError.new('You must explictly require "stir/rest", "stir/soap" or "stir/all"')