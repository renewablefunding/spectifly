require 'yaml'
require_relative 'field'
require_relative 'association'
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
        [fields.map(&:type) + associations.map(&:type)].flatten.compact.uniq
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
          @entity.fields.each do |name, attributes|
            fields << field_class.new(name.dup, attributes.dup)
          end
          fields
        end
      end

      def associations
        @associations ||= begin
          associations = []
          @entity.relationships.each do |relationship_type, type_associations|
            relationship_type = Spectifly::Support.tokenize(relationship_type)
            type_associations.each do |name, attributes|
              associations << association_class.new(
                name.dup, attributes.dup.merge(:relationship => relationship_type)
              )
            end
          end
          associations
        end
      end

      def utilized_extended_type_fields
        @utilized_extended_type_fields ||= begin
          fields = []
          utilized_extended_types.each do |name, attributes|
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

      def association_class
        eval("#{self.class.module_name}::Association")
      end

      def build
        raise 'Subclass Responsibility'
      end
    end
  end
end