require 'spec_helper'
require 'json'

describe Spectifly::Json::Builder do
  describe '#build' do
    it 'returns a hash representation of the entity' do
      entity = Spectifly::Entity.parse(fixture_path('individual'))
      json_path = expectation_path('individual', 'json')
      hash = described_class.new(entity).build
      JSON.pretty_generate(hash).should == File.read(json_path)
    end
  end

  describe '#present_as' do
    it 'filters entity through presenter, and returns self' do
      entity = Spectifly::Entity.parse(fixture_path('individual'))
      presenter_entity = Spectifly::Entity.parse(fixture_path('presenters/positionless_individual'))
      json_path = expectation_path('presented/positionless_individual', 'json')
      builder = described_class.new(entity)
      builder.present_as(presenter_entity).should == builder
      hash = builder.build
      JSON.pretty_generate(hash).should == File.read(json_path)
    end
  end
end