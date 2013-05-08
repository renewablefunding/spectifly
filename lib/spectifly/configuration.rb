module Spectifly
  class Configuration
    def initialize(config = {})
      @entity_path = config.fetch(:entity_path)
      @presenter_path = config[:presenter_path]
    end

    def presenter_path
      @presenter_path ||= begin
        proposed_path = File.join(@entity_path, 'presenters')
        if Dir.exists?(proposed_path)
          @presenter_path = proposed_path
        end
      end
    end
  end
end
