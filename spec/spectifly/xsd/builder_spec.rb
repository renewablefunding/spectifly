require 'json'

describe Spectifly::Xsd::Builder do
  describe '.from_path' do
    it 'generates builder from entity at given path' do
      path_builder = Spectifly::Xsd::Builder.from_path(fixture_path('individual'))
      xsd_path = expectation_path('individual', 'xsd')
      xsd = path_builder.build
      expect(xsd).to eq(File.read(xsd_path))
    end
  end

  describe '#build' do
    it 'returns an xsd representation of the entity' do
      entity = Spectifly::Entity.parse(fixture_path('individual'))
      xsd_path = expectation_path('individual', 'xsd')
      xsd = Spectifly::Xsd::Builder.new(entity).build
      expect(xsd).to eq(File.read(xsd_path))
    end

    it 'includes import directives for custom field types' do
      entity = Spectifly::Entity.parse(fixture_path('group'))
      xsd_path = expectation_path('group', 'xsd')
      xsd = Spectifly::Xsd::Builder.new(entity).build
      expect(xsd).to eq(File.read(xsd_path))
    end
  end

  describe '#present_as' do
    it 'filters entity through presenter, and returns self' do
      entity = Spectifly::Entity.parse(fixture_path('individual'))
      presenter_entity = Spectifly::Entity.parse(fixture_path('presenters/positionless_individual/individual'))
      xsd_path = expectation_path('presented/positionless_individual', 'xsd')
      builder = Spectifly::Xsd::Builder.new(entity)
      expect(builder.present_as(presenter_entity)).to eq(builder)
      xsd = builder.build
      expect(xsd).to eq(File.read(xsd_path))
    end

    it 'works with presented relationship-having entities' do
      entity = Spectifly::Entity.parse(fixture_path('group'))
      presenter_entity = Spectifly::Entity.parse(fixture_path('presenters/masterless_group/group'))
      xsd_path = expectation_path('presented/masterless_group', 'xsd')
      builder = Spectifly::Xsd::Builder.new(entity)
      expect(builder.present_as(presenter_entity)).to eq(builder)
      xsd = builder.build
      expect(xsd).to eq(File.read(xsd_path))
    end
  end
end
