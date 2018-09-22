require 'spec_helper'

RSpec.describe Brickset::Elements::Review do

  it 'knows its ancestors' do
    expect(described_class.ancestors).to include HappyMapper
  end

  it 'knows its tag' do
    expect(described_class.tag_name).to eq 'reviews'
  end

  describe '#parse' do
    let(:xml) { fixture('get_reviews.xml') }
    let(:parsed) { described_class.parse(xml, single: true) }

    it 'knows its attributes' do
      aggregate_failures do
        expect(parsed.author).to eq 'darth-vader'
        expect(parsed.title).to eq 'Ultimate Collector Series Millennium Falcon'
        expect(parsed.review).to match(/^A long time ago, in a Lego factory far, far away.../)
        expect(parsed.date_posted).to eq Date.parse('2010-10-01')
        expect(parsed.overall_rating).to eq 5
        expect(parsed.parts).to eq 5
        expect(parsed.building_experience).to eq 5
        expect(parsed.playability).to eq 3
        expect(parsed.value_for_money).to eq 4
        expect(parsed.html).to eq false
      end
    end
  end
end
