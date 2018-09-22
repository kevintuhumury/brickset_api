require 'spec_helper'

RSpec.describe Brickset::Elements::AdditionalImage do

  it 'knows its ancestors' do
    expect(described_class.ancestors).to include HappyMapper
  end

  it 'knows its tag' do
    expect(described_class.tag_name).to eq 'additionalImages'
  end

  describe '#parse' do
    let(:xml) { fixture('get_additional_images.xml') }
    let(:parsed) { described_class.parse(xml, single: true) }

    it 'knows its attributes' do
      aggregate_failures do
        expect(parsed.thumbnail_url).to eq 'https://images.brickset.com/sets/AdditionalImages/10179-1/tn_10179-0000-xx-13-1_jpg.jpg'
        expect(parsed.thumbnail_url).to eq 'https://images.brickset.com/sets/AdditionalImages/10179-1/tn_10179-0000-xx-13-1_jpg.jpg'
        expect(parsed.image_url).to eq 'https://images.brickset.com/sets/AdditionalImages/10179-1/10179-0000-xx-13-1.jpg'
      end
    end
  end

end
