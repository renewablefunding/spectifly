module Spectifly
  module Xsd
    class Association < Spectifly::Base::Association
      def name
        Spectifly::Support.camelize(@field_name).gsub(/\W/, '')
      end

      def to_xsd(builder = nil)
        builder ||= ::Builder::XmlMarkup.new(:indent => 2)
        if relationship == 'belongs_to'
          attributes['name'] = "#{name}Id"
          attributes['type'] = "xs:string"
        else
          attributes['name'] = name
          attributes['type'] = "#{Spectifly::Support.lower_camelize(type)}Type"
        end
        attributes['minOccurs'] = '0' unless required?
        attributes['maxOccurs'] = 'unbounded' if multiple?
        block = embedded_block
        builder.xs :element, attributes, &block
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
