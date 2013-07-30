require 'spec_helper'

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
    it 'returns configured value if set' do
      configuration = described_class.new(
        configuration_args.merge('presenter_path' => 'goose')
      )
      configuration.presenter_path.should == 'goose'
    end

    it 'returns nil if no presenter path exists at entity path' do
      configuration = described_class.new(
        configuration_args.merge('entity_path' => spec_path)
      )
      configuration.presenter_path.should be_nil
    end

    it 'returns {entity_path}/presenters if exists' do
      configuration = described_class.new(
        configuration_args
      )
      configuration.presenter_path.should == base_presenter_path
    end
  end
end
