require_relative 'entity_node'

module Spectifly
  module Base
    class Field < EntityNode
      def extract_attributes
        super
        @multiple = @attributes.delete('Multiple') == true
        if @tokens.include?('?') && @type && @type != 'Boolean'
          raise ArgumentError, "Boolean field has conflicting type"
        end
      end

      def extract_restrictions
        super
        ['Minimum Value', 'Maximum Value', 'Valid Values'].each do |restriction|
          if @attributes[restriction]
            token = Spectifly::Support.tokenize(restriction)
            @restrictions[token] = @attributes.delete(restriction)
          end
        end
        @validations.each do |validation|
          if validation =~ /^Must match regex "(.*)"$/
            @validations.delete(validation)
            @restrictions['regex'] = /#{$1}/
          end
        end
        @restrictions
      end

      def type
        type = super
        type = 'boolean' if @tokens.include?('?')
        type || 'string'
      end

      def multiple?
        @multiple
      end
    end
  end
end