require 'json'

describe Spectifly::Base::Builder do
  describe '.from_path' do
    it 'generates builder from entity at given path' do
      path_builder = described_class.from_path(fixture_path('individual'))
      expect(path_builder.root).to eq('Individual')
    end
  end

  describe '#build' do
    it 'raises subclass responsibility error' do
      entity = Spectifly::Entity.parse(fixture_path('individual'))
      expect {
        described_class.new(entity).build
      }.to raise_error("Subclass Responsibility")
    end
  end

  describe '#custom_types' do
    it 'return an array of all non-built-in types in result' do
      entity = Spectifly::Entity.parse(fixture_path('group'))
      expect(described_class.new(entity).custom_types).to match_array(['individual'])
    end
  end
end
