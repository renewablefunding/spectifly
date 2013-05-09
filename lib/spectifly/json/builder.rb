require_relative 'field'
require_relative 'association'
require_relative 'types'

module Spectifly
  module Json
    class Builder < Spectifly::Base::Builder
      def build
        field_hashes = {}
        associations.each do |association|
          field_hashes[association.relationship] ||= {}
          field_hashes[association.relationship].merge! association.to_h
        end
        fields.each do |field|
          field_hashes.merge! field.to_h
        end
        { Spectifly::Support.tokenize(root) => field_hashes }
      end
    end
  end
end