module Spectifly
  class Configuration
    class InvalidPresenterPath < StandardError; end
    attr_accessor :entity_path, :presenter_path

    def initialize(config = {})
      @entity_path = config.fetch('entity_path')
      set_presenter_path(config['presenter_path'])
    end

    private

    def set_presenter_path(path = nil)
      path = 'presenters' if path.nil?
      proposed_path = File.join(@entity_path, path)
      if Dir.exists?(proposed_path)
        @presenter_path = proposed_path
      else
        raise InvalidPresenterPath, "#{proposed_path} does not exist"
      end
    end
  end
end
