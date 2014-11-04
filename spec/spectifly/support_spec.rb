describe Spectifly::Support do

  describe '.camelize' do
    it 'removes underscores and spaces and capitalizes the first' do
      Spectifly::Support.camelize('foo_bar One two 3').should == 'FooBarOneTwo3'
    end

    it 'deals with nested classes' do
      Spectifly::Support.camelize('foo_bar/bar_foo').should == 'FooBar::BarFoo'
    end
  end

  describe '.lower_camelize' do
    it 'camelizes but with lowercase first character' do
      Spectifly::Support.lower_camelize('we Are the_toasty').should == 'weAreTheToasty'
      Spectifly::Support.lower_camelize('PleaseChange me').should == 'pleaseChangeMe'
    end
  end

  describe '.tokenize' do
    it 'creates snake_case version of string' do
      Spectifly::Support.tokenize('Albus Dumbledore & his_friend').should == 'albus_dumbledore_and_his_friend'
    end

    it 'uncamelizes' do
      Spectifly::Support.tokenize('thisStrangeJavalikeWord').should == 'this_strange_javalike_word'
    end

    it 'returns nil if given nil' do
      Spectifly::Support.tokenize(nil).should be_nil
    end
  end

  describe '.get_module' do
    it 'returns module from constant' do
      Spectifly::Support.get_module(Spectifly::Support).should == 'Spectifly'
    end

    it 'works with strings' do
      Spectifly::Support.get_module('Spectifly::Support').should == 'Spectifly'
    end

    it 'works with multiple parent modules' do
      Spectifly::Support.get_module('The::Way::It::Is').should == 'The::Way::It'
    end

    it 'returns nil if no module' do
      Spectifly::Support.get_module('LonelyConstant').should be_nil
    end
  end
end
