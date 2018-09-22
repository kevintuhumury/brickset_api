require 'spec_helper'

RSpec.describe Brickset::Elements::Condition do

  it 'knows its ancestors' do
    expect(described_class.ancestors).to include HappyMapper
  end

  it 'knows its tag' do
    expect(described_class.tag_name).to eq 'conditions'
  end

  describe '#parse' do
    let(:xml) { fixture('get_collection_detail_conditions.xml') }
    let(:parsed) { described_class.parse(xml, single: true) }

    it 'knows its attributes' do
      aggregate_failures do
        expect(parsed.condition).to eq 'Assembled'
      end
    end
  end
end
