describe Spectifly::Support do

  describe '.camelize' do
    it 'removes underscores and spaces and capitalizes the first' do
      expect(Spectifly::Support.camelize('foo_bar One two 3')).to eq('FooBarOneTwo3')
    end

    it 'deals with nested classes' do
      expect(Spectifly::Support.camelize('foo_bar/bar_foo')).to eq('FooBar::BarFoo')
    end
  end

  describe '.lower_camelize' do
    it 'camelizes but with lowercase first character' do
      expect(Spectifly::Support.lower_camelize('we Are the_toasty')).to eq('weAreTheToasty')
      expect(Spectifly::Support.lower_camelize('PleaseChange me')).to eq('pleaseChangeMe')
    end
  end

  describe '.tokenize' do
    it 'creates snake_case version of string' do
      expect(Spectifly::Support.tokenize('Albus Dumbledore & his_friend')).to eq('albus_dumbledore_and_his_friend')
    end

    it 'uncamelizes' do
      expect(Spectifly::Support.tokenize('thisStrangeJavalikeWord')).to eq('this_strange_javalike_word')
    end

    it 'returns nil if given nil' do
      expect(Spectifly::Support.tokenize(nil)).to be_nil
    end
  end

  describe '.get_module' do
    it 'returns module from constant' do
      expect(Spectifly::Support.get_module(Spectifly::Support)).to eq('Spectifly')
    end

    it 'works with strings' do
      expect(Spectifly::Support.get_module('Spectifly::Support')).to eq('Spectifly')
    end

    it 'works with multiple parent modules' do
      expect(Spectifly::Support.get_module('The::Way::It::Is')).to eq('The::Way::It')
    end

    it 'returns nil if no module' do
      expect(Spectifly::Support.get_module('LonelyConstant')).to be_nil
    end
  end
end
