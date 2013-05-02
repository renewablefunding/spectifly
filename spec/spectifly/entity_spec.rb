require 'spec_helper'

describe Spectifly::Entity do
  before :each do
    @entity = Spectifly::Entity.parse(fixture_path('individual'))
  end

  describe '#root' do
    it 'returns root element of parsed yaml' do
      @entity.root.should == 'Individual'
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
