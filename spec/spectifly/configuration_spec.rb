describe Spectifly::Configuration do
  let(:configuration_args) {
    {
      'entity_path' => base_fixture_path
    }
  }
  describe '.initialize' do
    it 'succeeds if entity and destination paths provided' do
      expect { described_class.new(configuration_args) }.not_to raise_error
    end

    it 'fails if no entity path provided' do
      configuration_args.delete('entity_path')
      expect { described_class.new(configuration_args) }.to raise_error
    end
  end

  describe '#presenter_path' do
    it 'raises an exception if configured value is set but does not exist' do
      expect{described_class.new(
        configuration_args.merge('presenter_path' => 'goose')
      )}.to raise_error(Spectifly::Configuration::InvalidPresenterPath)
    end

    it 'raises an exception if no default presenter path exists' do
      expect{described_class.new(
        configuration_args.merge('entity_path' => spec_path)
      )}.to raise_error(Spectifly::Configuration::InvalidPresenterPath)
    end

    it 'returns presenter path when passed in' do
      configuration = described_class.new(
        configuration_args.merge('presenter_path' => 'presenters/masterless_group')
      )
      expect(configuration.presenter_path).to eq(base_presenter_path + "/masterless_group")
    end

    it 'returns {entity_path}/presenters if exists' do
      configuration = described_class.new(
        configuration_args
      )
      expect(configuration.presenter_path).to eq(base_presenter_path)
    end
  end
end
