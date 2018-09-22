require 'spec_helper'

RSpec.describe Brickset::Elements::MinifigCollection do

  it 'knows its ancestors' do
    expect(described_class.ancestors).to include HappyMapper
  end

  it 'knows its tag' do
    expect(described_class.tag_name).to eq 'minifigCollection'
  end

  describe '#parse' do
    let(:xml) { fixture('get_minifig_collection.xml') }
    let(:parsed) { described_class.parse(xml, single: true) }

    it 'knows its attributes' do
      aggregate_failures do
        expect(parsed.minifig_number).to eq '85863pb076'
        expect(parsed.owned_in_sets).to eq 1
        expect(parsed.owned_loose).to eq 0
        expect(parsed.owned_total).to eq 1
        expect(parsed.wanted).to eq true
      end
    end
  end
end
