require 'spec_helper'

describe Spectifly::Base::EntityNode do
  describe 'uniqueness restriction' do
    it 'unique should be false by default and there should be no unique restriction' do
      field = described_class.new("Mini me")
      field.should_not be_unique
      field.restrictions.keys.should_not be_include('unique')
    end

    it 'adds a restriction and returns true for unique? if there is a uniqueness validation' do
      field = described_class.new("Little Snowflake", {"Validations" => "must be unique"})
      field.should be_unique
      field.restrictions.keys.include?('unique').should be_true
    end

    it 'adds a restriction and returns true for unique? if there is an attribute Unique set to true' do
      field = described_class.new("Little Snowflake", {"Unique" => "true"})
      field.should be_unique
      field.restrictions.keys.include?('unique').should be_true
    end

    it 'throws an error if the two ways of setting uniqueness contradict each other' do
      lambda {
      field = described_class.new("Little Snowflake?", {"Validations" => "must be unique", "Unique" => false})
      }.should raise_error
    end
  end
end