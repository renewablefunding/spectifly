require 'spec_helper'

describe Spectifly::Entity do
  before :each do
    @entity = Spectifly::Entity.parse(fixture_path('individual'))
  end

  describe '.from_directory' do
    it 'returns entities generated from files at given path' do
      entities = Spectifly::Entity.from_directory(fixture_path)
      entities.keys.should =~ ['individual', 'group']
      entities.values.map(&:class).uniq.should == [Spectifly::Entity]
      entities.values.map(&:name).should =~ ['individual', 'group']
    end

    it 'includes presenters if option passed' do
      entities = Spectifly::Entity.from_directory(
        fixture_path, :presenter_path => base_presenter_path
      )
      entities.keys.should =~ ['individual', 'group', 'positionless_individual']
      entities.values.map(&:class).uniq.should == [Spectifly::Entity]
      entities.values.map(&:name).should =~ ['individual', 'group', 'positionless_individual']
    end
  end

  describe '.parse' do
    it 'delegates to initializer' do
      Spectifly::Entity.should_receive(:new).with(:arguments)
      Spectifly::Entity.parse(:arguments)
    end
  end

  describe '.new' do
    it 'raises error if file not found' do
      expect {
        Spectifly::Entity.parse(fixture_path('missing'))
      }.to raise_error
    end

    it 'raises Invalid if file has multiple roots' do
      expect {
        Spectifly::Entity.parse(fixture_path('invalid/multiple_root'))
      }.to raise_error(Spectifly::Entity::Invalid)
    end

    it 'raises Invalid if file has no fields' do
      expect {
        Spectifly::Entity.parse(fixture_path('invalid/multiple_root'))
      }.to raise_error(Spectifly::Entity::Invalid)
    end
  end

  describe '#root' do
    it 'returns root element of parsed yaml' do
      @entity.root.should == 'Individual'
    end
  end

  describe '#name' do
    before :each do
      @presenter_entity = Spectifly::Entity.parse(
        fixture_path('presenters/positionless_individual')
      )
    end

    it 'returns name from entity file' do
      @entity.name.should == 'individual'
      @presenter_entity.name.should == 'positionless_individual'
    end

    it 'returns presenter name when presented' do
      @entity.present_as(@presenter_entity).name.should == 'positionless_individual'
    end
  end

  describe '#presented_as' do
    it 'returns nil if not presented' do
      @entity.presented_as.should be_nil
    end

    it 'returns presenter if presented' do
      @presenter_entity = Spectifly::Entity.parse(
        fixture_path('presenters/positionless_individual')
      )
      @entity.present_as(@presenter_entity).presented_as.should == @presenter_entity
    end
  end

  describe '#metadata' do
    it 'returns metadata from parsed yaml' do
      @entity.metadata.should == {
        "Description" => "An Individual"
      }
    end
  end

  describe '#fields' do
    it 'returns fields from parsed yaml' do
      @entity.fields.should == {
        "Name*" => {
          "Description" => "The individual's name",
          "Example" => "Randy McTougherson"
        },
        "Age" => {
          "Type" => "Integer",
          "Validations" => "Must be non-negative"
        },
        "Happiness" => {
          "Type" => "Percent",
          "Minimum Value" => 0,
          "Maximum Value" => 100
        },
        "Positions" => {
          "Description" => "Which positions individual occupies in a group",
          "Multiple" => true,
          "Valid Values" => [
            'Lotus',
            'Pole',
            'Third'
          ]
        },
        "Pickled?*" => {
          "Description" => "Whether or not this individual is pickled"
        }
      }
    end
  end

  describe '#present_as' do
    before :each do
      @presenter_entity = Spectifly::Entity.parse(fixture_path('presenters/positionless_individual'))
    end

    it 'raises exception if presenter entity has different root' do
      @presenter_entity.instance_variable_set(:@root, 'Whatever')
      expect {
        @entity.present_as(@presenter_entity)
      }.to raise_error(ArgumentError, "Presenter entity has different root")
    end

    it 'uses presenter fields only, but merges metadata and field attributes' do
      @merged_entity = @entity.present_as(@presenter_entity)
      @merged_entity.fields.should == {
        "Name*" => {
          "Description" => "The individual's name",
          "Example" => "Wussy O'Weakling"
        },
        "Age" => {
          "Type" => "Integer",
          "Validations" => "Must be non-negative"
        },
        "Joy" => {
          "Type" => "Percent",
          "Minimum Value" => 0,
          "Maximum Value" => 100,
          "Inherits From" => "Happiness"
        },
        "Pickled?" => {
          "Description" => "Whether or not this individual is pickled"
        }
      }
      @merged_entity.metadata.should == {
        "Description" => "A Positionless Individual"
      }
    end
  end
end
