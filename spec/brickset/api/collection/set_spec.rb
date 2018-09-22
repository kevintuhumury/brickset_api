require 'spec_helper'

RSpec.describe Brickset::Client, type: :model do
  let(:api_key) { Brickset.configuration.api_key }
  let(:token)   { 'valid' }

  subject { described_class.new(token: token) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:set_id).on :update_collection }
    it { is_expected.to validate_presence_of(:number_owned).on :update_collection }
    it { is_expected.to validate_presence_of(:wanted).on :update_collection }
    it { is_expected.to validate_inclusion_of(:number_owned).in_range(0..999).on :update_collection }
    it { is_expected.to validate_inclusion_of(:wanted).in_array([0, 1]).on :update_collection }

    it { is_expected.to validate_presence_of(:set_id).on :update_collection_owned }
    it { is_expected.to validate_presence_of(:owned).on :update_collection_owned }
    it { is_expected.to validate_inclusion_of(:owned).in_array([0, 1]).on :update_collection_owned }

    it { is_expected.to validate_presence_of(:set_id).on :update_collection_wanted }
    it { is_expected.to validate_presence_of(:wanted).on :update_collection_wanted }
    it { is_expected.to validate_inclusion_of(:wanted).in_array([0, 1]).on :update_collection_wanted }

    it { is_expected.to validate_presence_of(:set_id).on :update_collection_number_owned }
    it { is_expected.to validate_presence_of(:number_owned).on :update_collection_number_owned }
    it { is_expected.to validate_inclusion_of(:number_owned).in_range(0..999).on :update_collection_number_owned }

    it { is_expected.to validate_presence_of(:set_id).on :update_collection_user_notes }
    it { is_expected.to validate_presence_of(:notes).on :update_collection_user_notes }
    it { is_expected.to validate_length_of(:notes).is_at_most(200).on :update_collection_user_notes }

    it { is_expected.to validate_presence_of(:set_id).on :update_user_rating }
    it { is_expected.to validate_presence_of(:rating).on :update_user_rating }
    it { is_expected.to validate_inclusion_of(:rating).in_range(0..5).on :update_user_rating }
  end

  describe '#collection_totals' do
    let(:body) { fixture('get_collection_totals.xml') }

    before { stub_post('/getCollectionTotals').with(body: "apiKey=#{api_key}&userHash=#{token}").to_return body: body }

    context 'with valid parameters' do
      it 'returns the collection totals' do
        aggregate_failures do
          expect(subject.collection_totals).to be_a Brickset::Elements::CollectionTotal
          expect(subject.collection_totals.total_sets_owned).to eq 126
          expect(subject.collection_totals.total_sets_wanted).to eq 85
          expect(subject.collection_totals.total_minifigs_owned).to eq 156
          expect(subject.collection_totals.total_minifigs_wanted).to eq 40
          expect(subject.collection_totals.total_distinct_sets_owned).to eq 121
        end
      end
    end

    context 'with invalid parameters' do
      let(:token) { 'invalid' }
      let(:body) { fixture('get_collection_totals_no_result.xml') }

      it 'returns a collection total with default values' do
        aggregate_failures do
          expect(subject.collection_totals).to be_a Brickset::Elements::CollectionTotal
          expect(subject.collection_totals.total_sets_owned).to eq 0
          expect(subject.collection_totals.total_sets_wanted).to eq 0
          expect(subject.collection_totals.total_minifigs_owned).to eq 0
          expect(subject.collection_totals.total_minifigs_wanted).to eq 0
          expect(subject.collection_totals.total_distinct_sets_owned).to eq 0
        end
      end
    end
  end

  describe '#update_collection' do
    let(:set_id) { 26725 }
    let(:number_owned) { 2 }
    let(:wanted) { 1 }

    let(:update_collection) { subject.update_collection(set_id: set_id, number_owned: number_owned, wanted: wanted) }

    context 'when all required parameters are specified' do
      before { stub_post('/setCollection').with(body: "setID=#{set_id}&qtyOwned=#{number_owned}&wanted=#{wanted}&apiKey=#{api_key}&userHash=#{token}").to_return body: body }

      context 'when all parameters are valid' do
        let(:body) { fixture('set_collection.xml') }

        it 'updates the specified collection' do
          expect(update_collection).to eq true
        end
      end

      context 'when a parameter is invalid' do
        let(:body) { fixture('set_collection_invalid.xml') }

        it 'does not update the specified collection' do
          expect(update_collection).to eq false
        end

        it 'sets the error on the client' do
          update_collection
          expect(subject.errors[:base]).to match_array [ 'ERROR: invalid userHash' ]
        end
      end
    end

    context 'when not all parameters are valid' do
      let(:set_id) { nil }
      let(:wanted) { true }

      it 'raises a ValidationError' do
        expect { update_collection }.to raise_error Brickset::ValidationError, "Set can't be blank and Wanted is not included in the list"
      end
    end
  end

  describe '#update_collection_owned' do
    let(:set_id) { 26725 }
    let(:owned) { 1 }

    let(:update_collection_owned) { subject.update_collection_owned(set_id: set_id, owned: owned) }

    context 'when all required parameters are specified' do
      before { stub_post('/setCollection_owns').with(body: "setID=#{set_id}&owned=#{owned}&apiKey=#{api_key}&userHash=#{token}").to_return body: body }

      context 'when all parameters are valid' do
        let(:body) { fixture('set_collection_owns.xml') }

        it 'updates the specified collection owned' do
          expect(update_collection_owned).to eq true
        end
      end

      context 'when a parameter is invalid' do
        let(:body) { fixture('set_collection_owns_invalid.xml') }

        it 'does not update the specified collection owned' do
          expect(update_collection_owned).to eq false
        end

        it 'sets the error on the client' do
          update_collection_owned
          expect(subject.errors[:base]).to match_array [ 'ERROR: invalid userHash' ]
        end
      end
    end

    context 'when not all parameters are valid' do
      let(:set_id) { nil }
      let(:owned) { true }

      it 'raises a ValidationError' do
        expect { update_collection_owned }.to raise_error Brickset::ValidationError, "Set can't be blank and Owned is not included in the list"
      end
    end
  end

  describe '#update_collection_wanted' do
    let(:set_id) { 26725 }
    let(:wanted) { 1 }

    let(:update_collection_wanted) { subject.update_collection_wanted(set_id: set_id, wanted: wanted) }

    context 'when all required parameters are specified' do
      before { stub_post('/setCollection_wants').with(body: "setID=#{set_id}&wanted=#{wanted}&apiKey=#{api_key}&userHash=#{token}").to_return body: body }

      context 'when all parameters are valid' do
        let(:body) { fixture('set_collection_wants.xml') }

        it 'updates the specified collection wanted' do
          expect(update_collection_wanted).to eq true
        end
      end

      context 'when a parameter is invalid' do
        let(:body) { fixture('set_collection_wants_invalid.xml') }

        it 'does not update the specified collection wanted' do
          expect(update_collection_wanted).to eq false
        end

        it 'sets the error on the client' do
          update_collection_wanted
          expect(subject.errors[:base]).to match_array [ 'ERROR: invalid userHash' ]
        end
      end
    end

    context 'when not all parameters are valid' do
      let(:set_id) { nil }
      let(:wanted) { true }

      it 'raises a ValidationError' do
        expect { update_collection_wanted }.to raise_error Brickset::ValidationError, "Set can't be blank and Wanted is not included in the list"
      end
    end
  end

  describe '#update_collection_number_owned' do
    let(:set_id) { 26725 }
    let(:number_owned) { 1 }

    let(:update_collection_number_owned) { subject.update_collection_number_owned(set_id: set_id, number_owned: number_owned) }

    context 'when all required parameters are specified' do
      before { stub_post('/setCollection_qtyOwned').with(body: "setID=#{set_id}&qtyOwned=#{number_owned}&apiKey=#{api_key}&userHash=#{token}").to_return body: body }

      context 'when all parameters are valid' do
        let(:body) { fixture('set_collection_qty_owned.xml') }

        it 'updates the specified collection number owned' do
          expect(update_collection_number_owned).to eq true
        end
      end

      context 'when a parameter is invalid' do
        let(:body) { fixture('set_collection_qty_owned_invalid.xml') }

        it 'does not update the specified collection number owned' do
          expect(update_collection_number_owned).to eq false
        end

        it 'sets the error on the client' do
          update_collection_number_owned
          expect(subject.errors[:base]).to match_array [ 'ERROR: invalid userHash' ]
        end
      end
    end

    context 'when not all parameters are valid' do
      let(:set_id) { nil }
      let(:number_owned) { true }

      it 'raises a ValidationError' do
        expect { update_collection_number_owned }.to raise_error Brickset::ValidationError, "Set can't be blank and Number owned is not included in the list"
      end
    end
  end

  describe '#update_collection_user_notes' do
    let(:set_id) { 26725 }
    let(:notes) { "She's the fastest hunk of junk in the galaxy!" }

    let(:update_collection_user_notes) { subject.update_collection_user_notes(set_id: set_id, notes: notes) }

    context 'when all required parameters are specified' do
      before { stub_post('/setCollection_userNotes').with(body: "setID=#{set_id}&notes=#{ERB::Util.url_encode(notes)}&apiKey=#{api_key}&userHash=#{token}").to_return body: body }

      context 'when all parameters are valid' do
        let(:body) { fixture('set_collection_user_notes.xml') }

        it 'updates the specified collection user notes' do
          expect(update_collection_user_notes).to eq true
        end
      end

      context 'when a parameter is invalid' do
        let(:body) { fixture('set_collection_user_notes_invalid.xml') }

        it 'does not update the specified collection user notes' do
          expect(update_collection_user_notes).to eq false
        end

        it 'sets the error on the client' do
          update_collection_user_notes
          expect(subject.errors[:base]).to match_array [ 'ERROR: invalid userHash' ]
        end
      end
    end

    context 'when not all parameters are valid' do
      let(:set_id) { nil }
      let(:notes) { 'Star Wars. ' * 20 }

      it 'raises a ValidationError' do
        expect { update_collection_user_notes }.to raise_error Brickset::ValidationError, "Set can't be blank and Notes is too long (maximum is 200 characters)"
      end
    end
  end

  describe '#update_user_rating' do
    let(:set_id) { 26725 }
    let(:rating) { 4 }

    let(:update_user_rating) { subject.update_user_rating(set_id: set_id, rating: rating) }

    context 'when all required parameters are specified' do
      before { stub_post('/setUserRating').with(body: "setID=#{set_id}&rating=#{rating}&apiKey=#{api_key}&userHash=#{token}").to_return body: body }

      context 'when all parameters are valid' do
        let(:body) { fixture('set_user_rating.xml') }

        it 'updates the specified user rating' do
          expect(update_user_rating).to eq true
        end
      end

      context 'when a parameter is invalid' do
        let(:body) { fixture('set_user_rating_invalid.xml') }

        it 'does not update the specified user rating' do
          expect(update_user_rating).to eq false
        end

        it 'sets the error on the client' do
          update_user_rating
          expect(subject.errors[:base]).to match_array [ 'ERROR: invalid userHash' ]
        end
      end
    end

    context 'when not all parameters are valid' do
      let(:set_id) { nil }
      let(:rating) { 6 }

      it 'raises a ValidationError' do
        expect { update_user_rating }.to raise_error Brickset::ValidationError, "Set can't be blank and Rating is not included in the list"
      end
    end
  end

  describe '#user_notes' do
    let(:body) { fixture('get_user_notes.xml') }

    before { stub_post('/getUserNotes').with(body: "apiKey=#{api_key}&userHash=#{token}").to_return body: body }

    context 'with valid parameters' do
      it 'returns the users notes' do
        aggregate_failures do
          expect(subject.user_notes).to match_array [
            an_instance_of(Brickset::Elements::UserNote),
            an_instance_of(Brickset::Elements::UserNote)
          ]
          expect(subject.user_notes.count).to eq 2
          expect(subject.user_notes.first.set_id).to eq 5860
          expect(subject.user_notes.first.user_notes).to eq 'A long time ago in a galaxy far, far away...'
          expect(subject.user_notes.last.set_id).to eq 26725
          expect(subject.user_notes.last.user_notes).to eq 'The ship that made the Kessel Run in less than 12 parsecs.'
        end
      end
    end

    context 'with invalid parameters' do
      let(:token) { 'invalid' }
      let(:body) { fixture('get_user_notes_no_result.xml') }

      it 'does not receive any user notes' do
        expect(subject.user_notes).to match_array []
      end
    end
  end

end
