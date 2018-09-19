require 'spec_helper'

RSpec.describe Brickset::Configuration do
  describe '#api_key' do
    it 'knows its default value' do
      expect(subject.api_key).to be_nil
    end
  end
end
