require 'spec_helper'

RSpec.describe Brickset::Elements::Year do

  it 'knows its ancestors' do
    expect(described_class.ancestors).to include HappyMapper
  end

  it 'knows its tag' do
    expect(described_class.tag_name).to eq 'years'
  end

  describe '#parse' do
    let(:xml) { fixture('get_years.xml') }
    let(:parsed) { described_class.parse(xml, single: true) }

    it 'knows its attributes' do
      aggregate_failures do
        expect(parsed.theme).to eq 'Star Wars'
        expect(parsed.year).to eq '2016'
        expect(parsed.set_count).to eq 67
      end
    end
  end
end
