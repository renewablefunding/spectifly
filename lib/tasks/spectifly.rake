require 'spectifly/xsd'

namespace :spectifly do
  namespace :xsd do
    def write_entity(entity, path)
      File.open(File.join(path, "#{entity.name}.xsd"), 'w') do |f|
        f.write Spectifly::Xsd::Builder.new(entity).build
      end
    end

    Spectifly::Task.new('generate_from_entities', [:destination_path, :presenter_path]) do |spectifly, args|
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

    Spectifly::Task.new('generate_extended_types', [:destination_path, :presenter_path]) do |spectifly, args|
      extended = File.join(args[:destination_path], 'extended.xsd')
      File.open(extended, 'w') do |f|
        f.write Spectifly::Xsd::Types.build_extended
      end
      Dir.glob(File.join(args[:destination_path], '*/')).each do |path|
        next unless File.directory?(path)
        FileUtils.cp extended, path
      end
    end

    desc 'Generate all XSDs for the configured entity directory, including extended type definitions'
    task :generate_all, [:destination_path, :presenter_path] => [:generate_from_entities, :generate_extended_types]
  end
end
