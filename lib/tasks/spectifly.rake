namespace :spectifly do
  namespace :xsd do
    Spectifly::Task.new('generate_from_entities', [:destination_path]) do |spectifly, args|
      options = File.exist?(spectifly.presenter_path) ? { :presenter_path => spectifly.presenter_path } : {}

      Spectifly::Entity.from_directory(spectifly.entity_path, options).each do |name, entity|
        File.open(File.join(args[:destination_path], "#{name}.xsd"), 'w') do |f|
          f.write Spectifly::Xsd::Builder.new(entity).build
        end
      end
    end

    Spectifly::Task.new('generate_extended_types', [:destination_path]) do |spectifly, args|
      File.open(File.join(args[:destination_path], "extended.xsd"), 'w') do |f|
        f.write Spectifly::Xsd::Types.build_extended
      end
    end

    desc 'Generate all XSDs for the configured entity directory, including extended type definitions'
    task :generate_all, [:destination_path] => [:generate_from_entities, :generate_extended_types]
  end
end
