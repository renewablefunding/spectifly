describe Spectifly::Base::EntityNode do
  describe 'uniqueness restriction' do
    it 'unique should be false by default and there should be no unique restriction' do
      field = described_class.new("Mini me")
      expect(field).to_not be_unique
      expect(field.restrictions.keys.include?('unique')).to be_falsey
    end

    it 'adds a restriction and returns true for unique? if there is a uniqueness validation' do
      field = described_class.new("Little Snowflake", {"Validations" => "must be unique"})
      expect(field).to be_unique
      expect(field.restrictions.keys.include?('unique')).to be_truthy
    end

    it 'adds a restriction and returns true for unique? if there is an attribute Unique set to true' do
      field = described_class.new("Little Snowflake", {"Unique" => "true"})
      expect(field).to be_unique
      expect(field.restrictions.keys.include?('unique')).to be_truthy
    end

    it 'throws an error if the two ways of setting uniqueness contradict each other' do
      expect{
      field = described_class.new("Little Snowflake?", {"Validations" => "must be unique", "Unique" => false})
      }.to raise_error
    end
  end
end
