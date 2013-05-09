module Spectifly
  module Base
    class EntityNode
      attr_accessor :name, :attributes, :description, :example, :validations,
        :restrictions, :inherits_from

      def initialize(field_name, options = {})
        @field_name = field_name
        @tokens = @field_name.match(/(\W+)$/).to_s.scan(/./)
        @attributes = options
        extract_attributes
        extract_restrictions
      end

      def extract_attributes
        @description = @attributes.delete('Description')
        @example = @attributes.delete('Example')
        @type = @attributes.delete('Type')
        @inherits_from = @attributes.delete('Inherits From')
        @validations = [@attributes.delete('Validations')].compact.flatten
      end

      def extract_restrictions
        @restrictions = {}
        unique_validation = @validations.reject! { |v| v =~ /must be unique/i }
        unique_attribute = @attributes.delete("Unique")
        if (unique_validation && unique_attribute.nil?) ^ (unique_attribute.to_s == "true")
          @restrictions['unique'] = true
        elsif unique_validation && !["true", ""].include?(unique_attribute.to_s)
          raise "Field/association #{name} has contradictory information about uniqueness."
        end
      end

      def name
        Spectifly::Support.tokenize(@field_name).gsub(/\W/, '')
      end

      def type
        Spectifly::Support.tokenize(@type)
      end

      def display_type
        type
      end

      def unique?
        @restrictions['unique'] == true
      end

      def required?
        @tokens.include? '*'
      end
    end
  end
end