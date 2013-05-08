module Spectifly
  class Entity
    class Invalid < StandardError; end

    attr_reader :root, :path, :options, :name, :presented_as
    attr_accessor :metadata, :fields

    class << self
      def parse(*args)
        new(*args)
      end

      def from_directory(entities_path, options = {})
        presenter_path = options[:presenter_path]
        entities = {}
        entities_glob = File.join(entities_path, '*.entity')
        Dir[entities_glob].each do |path|
          path = File.expand_path(path)
          entity = Spectifly::Entity.parse(path)
          entities[entity.name] = entity
        end
        if presenter_path
          presenters_glob = File.join(presenter_path, '*.entity')
          Dir[presenters_glob].each do |path|
            path = File.expand_path(path)
            presenter = Spectifly::Entity.parse(path)
            base_entity = entities[Spectifly::Support.tokenize(presenter.root)]
            entity = base_entity.present_as(presenter)
            entities[entity.name] = entity
          end
        end
        entities
      end
    end

    def initialize(path, options = {})
      @options = options
      @path = path
      @name = File.basename(@path).sub(/(.*)\.entity$/, '\1')
      @parsed_yaml = YAML.load_file(@path)
      @root = @parsed_yaml.keys.first
      @metadata = @parsed_yaml.values.first
      @fields = @metadata.delete('Fields')
      if @presented_as = options[:presenter]
        @path = @presented_as.path
        @name = @presented_as.name
      end
      unless valid?
        raise Invalid, @errors.join(', ')
      end
    end

    def valid?
      @errors = []
      @errors << 'Exactly one root element required' unless @parsed_yaml.count == 1
      @errors << 'Entity is missing "Fields" key' if @fields.nil?
      @errors.empty?
    end

    def attributes_for_field_by_base_name(base_name)
      @fields.select { |name, attributes|
        name.gsub(/\W+$/, '') == base_name
      }.values.first
    end

    def present_as(presenter_entity)
      unless @root == presenter_entity.root
        raise ArgumentError, "Presenter entity has different root"
      end
      merged_fields = {}
      presenter_entity.fields.each_pair do |name, attributes|
        attributes ||= {}
        inherit_from = attributes['Inherits From'] || name.gsub(/\W+$/, '')
        parent_attrs = attributes_for_field_by_base_name(inherit_from)
        merged_fields[name] = (parent_attrs || {}).merge(attributes)
      end

      merged_entity = self.class.parse(
        path, options.merge(:presenter => presenter_entity)
      )
      merged_entity.fields = merged_fields
      merged_entity.metadata.merge!(presenter_entity.metadata)
      merged_entity
    end
  end
end