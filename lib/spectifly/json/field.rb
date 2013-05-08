module Spectifly
  module Json
    class Field < Spectifly::Base::Field
      def to_h
        fields = {
          :type => type,
          :multiple => multiple?,
          :required => required?,
        }
        [:description, :example, :validations, :restrictions].each do |opt|
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