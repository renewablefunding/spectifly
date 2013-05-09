module Spectifly
  module Json
    class Association < Spectifly::Base::Association
      def to_h
        fields = {
          :type => type,
          :required => required?,
        }
        [:description, :example, :restrictions].each do |opt|
          value = self.send(opt)
          if value && !value.empty?
            fields[opt] = value
          end
        end
        { name.to_sym => fields}
      end
    end
  end
end