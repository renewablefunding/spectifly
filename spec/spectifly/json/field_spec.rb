describe Spectifly::Json::Field do
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

      field = described_class.new('A Field*', {
        'Description' => "People who don't worry about longevity",
        'Type' => 'people',
        'Example' => 'children',
        'Validations' => ['Must be young', 'Must love eating mud']
      })
      expect(field.to_h).to eq(expected)
    end
  end
end
