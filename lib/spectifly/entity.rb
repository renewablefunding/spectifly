module Spectifly
  class Entity
    attr_reader :root, :path, :options
    attr_accessor :metadata, :fields

    def self.parse(*args)
      new(*args)
    end

    def initialize(path, options = {})
      @options = options
      @path = path
      @parsed_yaml = YAML.load_file(@path)
      raise 'Exactly one root element required' unless @parsed_yaml.count == 1
      @root = @parsed_yaml.keys.first
      @metadata = @parsed_yaml.values.first
      @fields = @metadata.delete('Fields')
    end

    def present_as(presenter_entity)
      unless @root == presenter_entity.root
        raise ArgumentError, "Presenter entity has different root"
      end
      merged_fields = {}
      presenter_entity.fields.each_pair do |name, attributes|
        attributes ||= {}
        parent_field = @fields[attributes['Inherits From'] || name]
        merged_fields[name] = (parent_field || {}).merge(attributes)
      end

      merged_entity = self.class.parse(path, options)
      merged_entity.fields = merged_fields
      merged_entity.metadata.merge!(presenter_entity.metadata)
      merged_entity
    end
  end
end