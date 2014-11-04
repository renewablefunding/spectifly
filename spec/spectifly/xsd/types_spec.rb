describe Spectifly::Xsd::Types do
  describe '.build_extended' do
    it 'builds xsd for extended types' do
      expected_path = expectation_path('extended', 'xsd')
      expected = File.read(expected_path)
      Spectifly::Xsd::Types.build_extended.should == expected
    end
  end
end
