require 'spec_helper'

RSpec.describe Brickset::Elements::UserNote do

  it 'knows its ancestors' do
    expect(described_class.ancestors).to include HappyMapper
  end

  it 'knows its tag' do
    expect(described_class.tag_name).to eq 'userNotes'
  end

  describe '#parse' do
    let(:xml) { fixture('get_user_notes.xml') }
    let(:parsed) { described_class.parse(xml, single: true) }

    it 'knows its attributes' do
      aggregate_failures do
        expect(parsed.set_id).to eq 5860
        expect(parsed.user_notes).to eq 'A long time ago in a galaxy far, far away...'
      end
    end
  end
end
