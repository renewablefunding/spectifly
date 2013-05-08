require 'yaml'
require_relative 'field'
require_relative 'types'

module Spectifly
  module Base
    class Builder
      class << self
        def from_path(path, options = {})
          new(Spectifly::Entity.parse(path), options)
        end

        def module_name
          Spectifly::Support.get_module(self)
        end
      end

      def initialize(entity, options = {})
        @options = options
        @entity = entity
      end

      def present_as(presenter_entity)
        @entity = @entity.present_as(presenter_entity)
        self
      end

      def types
        fields.map(&:type).compact.uniq
      end

      def native_types
        @native_types ||= begin
          eval("#{self.class.module_name}::Types::Native")
        end
      end

      def utilized_extended_types
        @utilized_extended_types ||= begin
          extended_types = eval("#{self.class.module_name}::Types::Extended")
          extended_types.select { |k, v| types.include?(k) }
        end
      end

      def custom_types
        types - native_types - utilized_extended_types.keys
      end

      def fields
        @fields ||= begin
          fields = []
          @entity.fields.each_pair do |name, attributes|
            fields << field_class.new(name.dup, attributes.dup)
          end
          fields
        end
      end

      def utilized_extended_type_fields
        @utilized_extended_type_fields ||= begin
          fields = []
          utilized_extended_types.each_pair do |name, attributes|
            fields << field_class.new(name.dup, attributes.dup)
          end
          fields
        end
      end

      def root
        @entity.root
      end

      def field_class
        eval("#{self.class.module_name}::Field")
      end

      def build
        raise 'Subclass Responsibility'
      end
    end
  end
end