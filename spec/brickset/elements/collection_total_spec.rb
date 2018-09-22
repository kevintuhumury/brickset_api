require 'spec_helper'

RSpec.describe Brickset::Elements::CollectionTotal do

  it 'knows its ancestors' do
    expect(described_class.ancestors).to include HappyMapper
  end

  it 'knows its tag' do
    expect(described_class.tag_name).to eq 'collectionTotals'
  end

  describe '#parse' do
    let(:xml) { fixture('get_collection_totals.xml') }
    let(:parsed) { described_class.parse(xml, single: true) }

    it 'knows its attributes' do
      aggregate_failures do
        expect(parsed.total_sets_owned).to eq 126
        expect(parsed.total_sets_wanted).to eq 85
        expect(parsed.total_distinct_sets_owned).to eq 121
        expect(parsed.total_minifigs_owned).to eq 156
        expect(parsed.total_minifigs_wanted).to eq 40
      end
    end
  end
end
