require 'spec_helper'

RSpec.describe Brickset::Elements::Set do

  it 'knows its ancestors' do
    expect(described_class.ancestors).to include HappyMapper
  end

  it 'knows its tag' do
    expect(described_class.tag_name).to eq 'sets'
  end

  describe '#parse' do
    let(:xml) { fixture('get_sets.xml') }
    let(:parsed) { described_class.parse(xml, single: true) }

    it 'knows its attributes' do
      aggregate_failures do
        expect(parsed.id).to eq 5860
        expect(parsed.number).to eq '10179'
        expect(parsed.number_variant).to eq 1
        expect(parsed.name).to eq "Ultimate Collector's Millennium Falcon"
        expect(parsed.year).to eq '2007'
        expect(parsed.description).to be_nil
        expect(parsed.category).to eq 'Normal'
        expect(parsed.theme).to eq 'Star Wars'
        expect(parsed.theme_group).to eq 'Licensed'
        expect(parsed.subtheme).to eq 'Ultimate Collector Series'
        expect(parsed.pieces).to eq '5197'
        expect(parsed.minifigs).to eq '5'
        expect(parsed.image).to eq true
        expect(parsed.image_url).to eq 'https://images.brickset.com/sets/images/10179-1.jpg'
        expect(parsed.image_filename).to eq '10179-1'
        expect(parsed.thumbnail_url).to eq 'https://images.brickset.com/sets/thumbs/tn_10179-1_jpg.jpg'
        expect(parsed.thumbnail_url_large).to eq 'https://images.brickset.com/sets/small/10179-1.jpg'
        expect(parsed.brickset_url).to eq 'https://brickset.com/sets/10179-1'
        expect(parsed.owned_by_total).to eq 3807
        expect(parsed.wanted_by_total).to eq 9349
        expect(parsed.released).to eq true
        expect(parsed.rating).to eq 4.76190476190476
        expect(parsed.user_rating).to eq 0
        expect(parsed.review_count).to eq 21
        expect(parsed.instructions_count).to eq 1
        expect(parsed.additional_image_count).to eq 5
        expect(parsed.last_updated).to eq Date.parse('2017-08-23')
        expect(parsed.age_minimum).to eq 16
        expect(parsed.age_maximum).to be_nil
        expect(parsed.notes).to be_nil
        expect(parsed.tags).to be_nil
        expect(parsed.retail_price_uk).to eq '342.49'
        expect(parsed.retail_price_us).to eq '499.99'
        expect(parsed.retail_price_ca).to eq ''
        expect(parsed.retail_price_eu).to eq ''
        expect(parsed.date_added_to_shop).to eq '2007-10-24'
        expect(parsed.date_removed_from_shop).to eq '2010-05-04'
        expect(parsed.packaging_type).to eq 'Box'
        expect(parsed.height).to eq 0.0
        expect(parsed.width).to eq 0.0
        expect(parsed.depth).to eq 0.0
        expect(parsed.weight).to eq 0.0
        expect(parsed.availability).to eq 'LEGO exclusive'
        expect(parsed.ean).to eq ''
        expect(parsed.upc).to eq ''
        expect(parsed.acm_data_count).to eq 0
        expect(parsed.owned).to eq false
        expect(parsed.wanted).to eq true
        expect(parsed.number_owned).to eq 0
        expect(parsed.user_notes).to eq 'A long time ago in a galaxy far, far away...'
      end
    end
  end
end
