require 'spec_helper'

describe Spectifly::Field do
  describe '#name' do
    it 'returns tokenized version of field name' do
      field = Spectifly::Field.new('A really cool hat')
      field.name.should == 'a_really_cool_hat'
    end
  end

  describe '.initialize' do
    it 'throws an exception if Boolean shortcut conflicts with type' do
      expect {
        Spectifly::Field.new('Caramel tuba?', 'Type' => 'DateTime')
      }.to raise_error(ArgumentError, "Boolean field has conflicting type")
    end
  end

  describe '#type' do
    it 'defaults to string if no type specified' do
      field = Spectifly::Field.new('A really cool hat')
      field.type.should == 'string'
    end

    it 'returns boolean if field name has "?" token' do
      field = Spectifly::Field.new('A really cool hat?')
      field.type.should == 'boolean'
    end

    it 'returns type if specified' do
      field = Spectifly::Field.new('some field', 'Type' => 'Rhubarb')
      field.type.should == 'rhubarb'
    end
  end

  describe '#extract_restrictions' do
    it 'sets up minimum and maximum value restrictions' do
      field = Spectifly::Field.new('some field', {
        'Minimum Value' => 3, 'Maximum Value' => 145
      })
      field.restrictions.should == {
        'minimum_value' => 3,
        'maximum_value' => 145
      }
    end

    it 'sets up enumerations' do
      field = Spectifly::Field.new('some field', {
        'Valid Values' => [34, 52, 100, 4]
      })
      field.restrictions.should == {
        'valid_values' => [34, 52, 100, 4]
      }
    end

    it 'pulls regex restriction from validations' do
      field = Spectifly::Field.new('some field', {
        'Validations' => 'Must match regex "^[0-9]{4}"'
      })
      field.validations.should be_empty
      field.restrictions.should == {
        'regex' => /^[0-9]{4}/
      }
    end

    it 'sets restrictions to empty hash if none exist' do
      field = Spectifly::Field.new('some field')
      field.restrictions.should be_empty
    end
  end

  describe '#multiple?' do
    it 'returns true if multiple set to true' do
      field = Spectifly::Field.new('some field', 'Multiple' => true)
      field.should be_multiple
    end

    it 'returns false if multiple set to anything but true' do
      field = Spectifly::Field.new('some field', 'Multiple' => 'Whatever')
      field.should_not be_multiple
    end

    it 'returns false if multiple not set' do
      field = Spectifly::Field.new('some field')
      field.should_not be_multiple
    end
  end

  describe '#required?' do
    it 'returns true if field name has "*" token' do
      field = Spectifly::Field.new('some field*')
      field.should be_required
    end

    it 'returns false if field name does not have "*" token' do
      field = Spectifly::Field.new('some field')
      field.should_not be_required
    end
  end

  describe '#to_h' do
    it 'returns hash format of field' do
      expected = {
        :a_field => {
          :type => 'people',
          :multiple => false,
          :required => true,
          :description => "People who don't worry about longevity",
          :example => 'children',
          :validations => ['Must be young', 'Must love eating mud']
        }
      }

      field = Spectifly::Field.new('A Field*', {
        'Description' => "People who don't worry about longevity",
        'Type' => 'people',
        'Example' => 'children',
        'Validations' => ['Must be young', 'Must love eating mud']
      })
      field.to_h.should == expected
    end
  end
end