require 'spec_helper'

RSpec.describe Brickset::Elements::Subtheme do

  it 'knows its ancestors' do
    expect(described_class.ancestors).to include HappyMapper
  end

  it 'knows its tag' do
    expect(described_class.tag_name).to eq 'subthemes'
  end

  describe '#parse' do
    let(:xml) { fixture('get_subthemes.xml') }
    let(:parsed) { described_class.parse(xml, single: true) }

    it 'knows its attributes' do
      aggregate_failures do
        expect(parsed.theme).to eq 'Star Wars'
        expect(parsed.subtheme).to eq 'Ultimate Collector Series'
        expect(parsed.set_count).to eq 30
        expect(parsed.year_from).to eq 2000
        expect(parsed.year_to).to eq 2018
      end
    end
  end
end
