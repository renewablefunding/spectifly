require_relative 'types'

module Spectifly
  module Xsd
    class Field < Spectifly::Base::Field
      def name
        Spectifly::Support.camelize(@field_name).gsub(/\W/, '')
      end

      def name_as_type
        Spectifly::Support.lower_camelize("#{name}Type")
      end

      def display_type
        prefix = if @validations.include?('Must be positive')
          'positive_'
        elsif @validations.include?('Must be non-negative')
          'non_negative_'
        end
        prefixed_type = "#{prefix}#{type}"
        camel_type = Spectifly::Support.lower_camelize(prefixed_type)
        if Spectifly::Xsd::Types::Native.include?(prefixed_type)
          "xs:#{camel_type}"
        else
          "#{camel_type}Type"
        end
      end

      def to_xsd(builder = nil)
        builder ||= ::Builder::XmlMarkup.new(:indent => 2)
        attributes['type'] = display_type if restrictions.empty?
        attributes['minOccurs'] = '0' unless required?
        attributes['maxOccurs'] = 'unbounded' if multiple?
        block = embedded_block
        builder.xs :element, { :name => name }.merge(attributes), &block
      end

      def regex
        return nil unless restrictions['regex']
        regex = restrictions['regex'].source
        if regex =~ /^(\^)?([^\$]*)(\$)?$/
          prefix = '[\s\S]*' unless $1
          suffix = '[\s\S]*' unless $3
          regex = "#{prefix}#{$2}#{suffix}"
        end
        regex
      end

      def type_block(use_name = false)
        type_attributes = { :name => name_as_type } if use_name
        Proc.new { |el|
          el.xs :simpleType, type_attributes do |st|
            st.xs :restriction, :base => display_type, &restrictions_block
          end
        }
      end

      def restrictions_block
        if !restrictions.empty?
          Proc.new { |el|
            el.xs :minInclusive, :value => restrictions['minimum_value'] if restrictions['minimum_value']
            el.xs :maxInclusive, :value => restrictions['maximum_value'] if restrictions['maximum_value']
            el.xs :pattern, :value => regex if regex
            (restrictions['valid_values'] || []).each do |vv|
              el.xs :enumeration, :value => vv
            end
          }
        end
      end

      def embedded_block
        if description || example || !restrictions.empty?
          Proc.new { |el|
            if description || example
              el.xs :annotation do |ann|
                ann.xs :documentation, description if description
                ann.xs :documentation, "Example: #{example}" if example
              end
            end
            type_block.call(el) unless restrictions.empty?
          }
        end
      end
    end
  end
end