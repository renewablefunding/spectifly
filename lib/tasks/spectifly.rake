require 'spectifly/xsd'

namespace :spectifly do
  namespace :xsd do
    def write_entity(entity, path)
      File.open(File.join(path, "#{entity.name}.xsd"), 'w') do |f|
        f.write Spectifly::Xsd::Builder.new(entity).build
      end
    end

    Spectifly::Task.new('generate_from_entities', [:destination_path]) do |spectifly, args|
      options = File.exist?(spectifly.presenter_path) ? { :presenter_path => spectifly.presenter_path } : {}

      Spectifly::Entity.from_directory(spectifly.entity_path, options).each do |name, entity|
        if entity.is_a? Spectifly::Entity
          write_entity(entity, args[:destination_path])
        else
          presenter_path = File.join(args[:destination_path], name)
          FileUtils.mkdir_p presenter_path unless File.exist? presenter_path
          entity.each do |presenter_entity_name, presenter_entity|
            write_entity(presenter_entity, presenter_path)
          end
        end
      end
    end

    Spectifly::Task.new('generate_extended_types', [:destination_path]) do |spectifly, args|
      File.open(File.join(args[:destination_path], "extended.xsd"), 'w') do |f|
        f.write Spectifly::Xsd::Types.build_extended
      end
    end

    Spectifly::Task.new('package_presenter_schemas', [:destination_path]) do |spectifly, args|
      # just copy all the xsds over into each directory (naively assuming all directories are presenters), for easy zipping and whatnot
      schema = Dir.glob(File.join(args[:destination_path], '*.xsd'))
      Dir.glob(File.join(args[:destination_path], '*/')).each do |path|
        FileUtils.cp schema, path
      end
    end

    desc 'Generate all XSDs for the configured entity directory, including extended type definitions'
    task :generate_all, [:destination_path] => [:generate_from_entities, :generate_extended_types, :package_presenter_schemas]
  end
end
