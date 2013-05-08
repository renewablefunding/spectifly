namespace :spectifly do
  desc 'Do whatever'
  Spectifly::Task.new('whatever') do |sfly|
    sfly.config_path = File.join(Rake.original_dir, 'config', 'spectifly.yml')
  end
end