require_relative 'field'
require_relative 'types'

module Spectifly
  module Json
    class Builder < Spectifly::Base::Builder
      def build
        field_hashes = {}
        fields.each do |field|
          field_hashes.merge! field.to_h
        end
        { Spectifly::Support.tokenize(root) => field_hashes }
      end
    end
  end
end