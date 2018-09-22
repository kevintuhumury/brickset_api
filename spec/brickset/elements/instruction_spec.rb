require 'spec_helper'

RSpec.describe Brickset::Elements::Instruction do

  it 'knows its ancestors' do
    expect(described_class.ancestors).to include HappyMapper
  end

  it 'knows its tag' do
    expect(described_class.tag_name).to eq 'instructions'
  end

  describe '#parse' do
    let(:xml) { fixture('get_instructions.xml') }
    let(:parsed) { described_class.parse(xml, single: true) }

    it 'knows its attributes' do
      aggregate_failures do
        expect(parsed.url).to eq 'https://www.lego.com/biassets/bi/4525430.pdf'
        expect(parsed.description).to eq 'Building instruction 10179'
      end
    end
  end
end
