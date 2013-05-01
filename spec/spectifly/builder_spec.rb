require 'spec_helper'
require 'json'

describe Spectifly::Builder do
  describe '.from_path' do
    it 'generates builder from entity at given path' do
      path_builder = Spectifly::Builder.from_path(fixture_path('individual'))
      json_path = expectation_path('individual', 'json')
      hash = path_builder.build
      JSON.pretty_generate(hash).should == File.read(json_path)
    end
  end

  describe '#build' do
    it 'returns a hash representation of the entity' do
      entity = Spectifly::Entity.parse(fixture_path('individual'))
      json_path = expectation_path('individual', 'json')
      hash = Spectifly::Builder.new(entity).build
      JSON.pretty_generate(hash).should == File.read(json_path)
    end
  end

  describe '#custom_types' do
    it 'return an array of all non-built-in types in result' do
      entity = Spectifly::Entity.parse(fixture_path('group'))
      Spectifly::Builder.new(entity).custom_types.should =~ [
        'individual'
      ]
    end
  end

  describe '#present_as' do
    it 'filters entity through presenter, and returns self' do
      entity = Spectifly::Entity.parse(fixture_path('individual'))
      presenter_entity = Spectifly::Entity.parse(fixture_path('presenters/positionless_individual'))
      json_path = expectation_path('presented/positionless_individual', 'json')
      builder = Spectifly::Builder.new(entity)
      builder.present_as(presenter_entity).should == builder
      hash = builder.build
      JSON.pretty_generate(hash).should == File.read(json_path)
    end
  end
end