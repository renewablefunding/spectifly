module Spectifly
  module Support
    module_function

    def camelize(string, lower = false)
      string = if lower
        string.sub(/^[A-Z\d]*/) { $&.downcase }
      else
        string.sub(/^[a-z\d]*/) { $&.capitalize }
      end
      string = string.gsub(/(?:_| |(\/))([a-z\d]*)/) { "#{$1}#{$2.capitalize}" }.gsub('/', '::')
    end

    def lower_camelize(string)
      camelize(string, true)
    end

    def tokenize(string)
      string = string.gsub(/&/, ' and ').
        gsub(/[ \/]+/, '_').
        gsub(/([a-z\d])([A-Z])/,'\1_\2').
        downcase
    end

    def get_module(constant)
      tokens = constant.to_s.split('::')
      module_name = tokens[0, tokens.length - 1].join('::')
      module_name == '' ? nil : module_name
    end
  end
end