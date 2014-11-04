describe Spectifly::Entity do
  before :each do
    @entity = Spectifly::Entity.parse(fixture_path('individual'))
  end

  describe '.from_directory' do
    it 'returns entities generated from files at given path' do
      entities = Spectifly::Entity.from_directory(fixture_path)
      expect(entities.keys).to match_array(['individual', 'group'])
      expect(entities.values.map(&:class).uniq).to eq([Spectifly::Entity])
      expect(entities.values.map(&:name)).to match_array(['individual', 'group'])
    end

    it 'includes presenters if option passed' do
      entities = Spectifly::Entity.from_directory(
        fixture_path, :presenter_path => base_presenter_path
      )

      expect(entities.keys).to match_array(['individual', 'group', 'positionless_individual', 'masterless_group'])
      expect(entities['positionless_individual'].keys).to eq(['individual'])
      expect(entities['positionless_individual'].values.map(&:name)).to eq(['individual'])
      expect(entities['masterless_group'].keys).to eq(['group'])
      expect(entities['masterless_group'].values.map(&:name)).to eq(['group'])
      ['positionless_individual', 'masterless_group'].each do |presenter|
        expect(entities[presenter].values.map(&:class).uniq).to eq([Spectifly::Entity])
      end
    end
  end

  describe '.parse' do
    it 'delegates to initializer' do
      expect(Spectifly::Entity).to receive(:new).with(:arguments)
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
      expect(@entity.root).to eq('Individual')
    end
  end

  describe '#name' do
    before :each do
      @presenter_entity = Spectifly::Entity.parse(
        fixture_path('presenters/positionless_individual/individual.entity')
      )
    end

    it 'returns name from entity file' do
      expect(@entity.name).to eq('individual')
      expect(@presenter_entity.name).to eq('individual')
    end

    it 'returns presenter name when presented' do
      expect(@entity.present_as(@presenter_entity).name).to eq('individual')
    end
  end

  describe '#presented_as' do
    it 'returns nil if not presented' do
      expect(@entity.presented_as).to be_nil
    end

    it 'returns presenter if presented' do
      @presenter_entity = Spectifly::Entity.parse(
        fixture_path('presenters/positionless_individual/individual.entity')
      )
      expect(@entity.present_as(@presenter_entity).presented_as).to eq(@presenter_entity)
    end
  end

  describe '#metadata' do
    it 'returns metadata from parsed yaml' do
      expect(@entity.metadata).to eq({
        "Description" => "An Individual"
      })
    end
  end

  describe '#fields' do
    it 'returns fields from parsed yaml' do
      expect(@entity.fields).to eq({
        "Name*" => {
          "Description" => "The individual's name",
          "Example" => "Randy McTougherson",
          "Unique" => true
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
      })
    end
  end

  describe '#present_as' do
    before :each do
      @presenter_entity = Spectifly::Entity.parse(fixture_path('presenters/positionless_individual/individual'))
    end

    it 'raises exception if presenter entity has different root' do
      @presenter_entity.instance_variable_set(:@root, 'Whatever')
      expect {
        @entity.present_as(@presenter_entity)
      }.to raise_error(ArgumentError, "Presenter entity has different root")
    end

    it 'uses presenter fields only, but merges metadata and field attributes' do
      @merged_entity = @entity.present_as(@presenter_entity)
      expect(@merged_entity.fields).to eq({
        "Name*" => {
          "Description" => "The individual's name",
          "Example" => "Wussy O'Weakling",
          "Unique" => true
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
      })
      expect(@merged_entity.metadata).to eq({
        "Description" => "A Positionless Individual"
      })
    end
  end

  describe '#relationships' do
    it 'returns relationships from parsed yaml' do
      @group_entity = Spectifly::Entity.parse(fixture_path('group'))
      expect(@group_entity.relationships).to eq({
        "Has Many" => {
          "Peeps" => {
            "Description" => "Who is in the group",
            "Type" => "Individual"
          }
        },
        "Has One" => {
          "Master*" => {
            "Description" => "Who is the master of the group",
            "Type" => "Individual"
          }
        }
      })
    end
  end
end
