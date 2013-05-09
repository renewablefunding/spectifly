module Spectifly
  module Xsd
    class Association < Spectifly::Base::Association
      def name
        Spectifly::Support.camelize(@field_name).gsub(/\W/, '')
      end

      def to_xsd(builder = nil)
        builder ||= ::Builder::XmlMarkup.new(:indent => 2)
        attributes['type'] = "#{Spectifly::Support.lower_camelize(type)}Type"
        attributes['minOccurs'] = '0' unless required? && relationship != 'belongs_to'
        attributes['maxOccurs'] = 'unbounded' if multiple?
        block = embedded_block
        builder.xs :element, { :name => name }.merge(attributes), &block
      end

      def embedded_block
        if description || example
          Proc.new { |el|
            if description || example
              el.xs :annotation do |ann|
                ann.xs :documentation, description if description
                ann.xs :documentation, "Example: #{example}" if example
              end
            end
          }
        end
      end
    end
  end
end