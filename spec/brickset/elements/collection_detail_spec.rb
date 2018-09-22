require 'spec_helper'

RSpec.describe Brickset::Elements::CollectionDetail do

  it 'knows its ancestors' do
    expect(described_class.ancestors).to include HappyMapper
  end

  it 'knows its tag' do
    expect(described_class.tag_name).to eq 'collectionDetails'
  end

  describe '#parse' do
    let(:xml) { fixture('get_collection_detail.xml') }
    let(:parsed) { described_class.parse(xml, single: true) }

    it 'knows its attributes' do
      aggregate_failures do
        expect(parsed.collection_id).to eq 12712521
        expect(parsed.date_acquired).to eq '21-08-18'
        expect(parsed.currency).to eq 'EUR'
        expect(parsed.price_paid).to eq 3.0
        expect(parsed.additional_price_paid).to eq 0.49
        expect(parsed.current_estimated_value).to eq 3.49
        expect(parsed.condition_when_acquired).to eq 'As new'
        expect(parsed.acquired_from).to eq 'Mos Eisley'
        expect(parsed.condition_now).to eq 'Assembled'
        expect(parsed.location).to eq 'In a galaxy far, far away...'
        expect(parsed.notes).to eq 'A long time ago...'
        expect(parsed.parts).to eq true
        expect(parsed.minifigs).to eq false
        expect(parsed.instructions).to eq true
        expect(parsed.box).to eq true
        expect(parsed.modified).to eq true
        expect(parsed.will_trade).to eq false
        expect(parsed.deleted).to eq false
      end
    end
  end
end
