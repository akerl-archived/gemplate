require 'spec_helper'

describe Gemplate do
  describe '#new' do
    it 'creates cache objects' do
      expect(Gemplate.new).to be_an_instance_of Gemplate::Gem
    end
  end
end
