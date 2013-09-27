require_relative 'entity_node'

module Spectifly
  module Base
    class Association < EntityNode
      attr_reader :relationship

      def initialize(field_name, options = {})
        super
        @relationship = options.delete(:relationship)
      end

      def multiple?
        ['has_many', 'has_many_and_belongs_to', 'belongs_to_many'].include? relationship
      end
    end
  end
end
