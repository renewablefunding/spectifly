describe Spectifly::Xsd::Field do
  describe '#regex' do
    it 'formats regex to xsd-compatible pattern restriction' do
      field = Spectifly::Xsd::Field.new('some field', {
        'Validations' => 'Must match regex "^[0-9]{4}"'
      })
      expect(field.regex).to eq('[0-9]{4}[\s\S]*')
    end
  end
end
