describe Spectifly::Xsd::Types do
  describe '.build_extended' do
    it 'builds xsd for extended types' do
      expected_path = expectation_path('extended', 'xsd')
      expected = File.read(expected_path)
      expect(Spectifly::Xsd::Types.build_extended).to eq(expected)
    end
  end
end
