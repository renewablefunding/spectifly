module Spectifly
  class Field
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
      @multiple = @attributes.delete('Multiple') == true
      @type = @attributes.delete('Type')
      @inherits_from = @attributes.delete('Inherits From')
      if @tokens.include?('?') && @type && @type != 'Boolean'
        raise ArgumentError, "Boolean field has conflicting type"
      end
      @validations = [@attributes.delete('Validations')].compact.flatten
    end

    def extract_restrictions
      @restrictions = {}
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

    def name
      Spectifly::Support.tokenize(@field_name).gsub(/\W/, '')
    end

    def type
      type = @type
      type = 'boolean' if @tokens.include?('?')
      Spectifly::Support.tokenize(type || 'string')
    end

    def display_type
      type
    end

    def multiple?
      @multiple
    end

    def required?
      @tokens.include? '*'
    end

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