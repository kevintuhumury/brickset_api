require 'spec_helper'

RSpec.describe Brickset::Client, type: :model do
  let(:api_key) { Brickset.configuration.api_key }
  let(:token)   { 'valid' }

  subject { described_class.new(token: token) }

  context 'validations' do
    it { is_expected.to validate_presence_of(:minifig_number).on :update_minifig_collection }
    it { is_expected.to validate_presence_of(:number_owned).on :update_minifig_collection }
    it { is_expected.to validate_presence_of(:wanted).on :update_minifig_collection }
    it { is_expected.to validate_inclusion_of(:number_owned).in_range(0..999).on :update_minifig_collection }
    it { is_expected.to validate_inclusion_of(:wanted).in_array([0, 1]).on :update_minifig_collection }
  end

  describe '#minifig_collection' do
    context 'with valid parameters' do
      context 'when using the query parameter' do
        before { stub_post('/getMinifigCollection').with(body: "query=Star%20Wars&owned=&wanted=&apiKey=#{api_key}&userHash=#{token}").to_return body: fixture('get_minifig_collection.xml') }

        it 'returns the minifig collections that match the search query' do
          expect(subject.minifig_collection(query: 'Star Wars')).to match_array [
            an_instance_of(Brickset::Elements::MinifigCollection),
            an_instance_of(Brickset::Elements::MinifigCollection),
            an_instance_of(Brickset::Elements::MinifigCollection),
            an_instance_of(Brickset::Elements::MinifigCollection)
          ]
        end
      end

      context 'when using the owned parameter' do
        before { stub_post('/getMinifigCollection').with(body: "query=&owned=1&wanted=&apiKey=#{api_key}&userHash=#{token}").to_return body: fixture('get_minifig_collection_owned.xml') }

        it 'returns the owned minifig collections' do
          expect(subject.minifig_collection(owned: '1')).to match_array [
            an_instance_of(Brickset::Elements::MinifigCollection),
            an_instance_of(Brickset::Elements::MinifigCollection)
          ]
        end
      end
      context 'when using the wanted parameter' do
        before { stub_post('/getMinifigCollection').with(body: "query=&owned=&wanted=1&apiKey=#{api_key}&userHash=#{token}").to_return body: fixture('get_minifig_collection_wanted.xml') }

        it 'returns the wanted minifig collections' do
          expect(subject.minifig_collection(wanted: '1')).to match_array [
            an_instance_of(Brickset::Elements::MinifigCollection)
          ]
        end
      end
    end
  end

  describe '#update_minifig_collection' do
    let(:minifig_number) { '47205pb026' }
    let(:number_owned) { 2 }
    let(:wanted) { 1 }

    let(:update_minifig_collection) { subject.update_minifig_collection(minifig_number: minifig_number, number_owned: number_owned, wanted: wanted) }

    context 'when all required parameters are specified' do
      before { stub_post('/setMinifigCollection').with(body: "minifigNumber=#{minifig_number}&qtyOwned=#{number_owned}&wanted=#{wanted}&apiKey=#{api_key}&userHash=#{token}").to_return body: body }

      context 'when all parameters are valid' do
        let(:body) { fixture('set_minifig_collection.xml') }

        it 'updates the specified minifig collection' do
          expect(update_minifig_collection).to eq true
        end
      end

      context 'when a parameter is invalid' do
        let(:body) { fixture('set_minifig_collection_invalid.xml') }

        it 'does not update the specified minifig collection' do
          expect(update_minifig_collection).to eq false
        end

        it 'sets the error on the client' do
          update_minifig_collection
          expect(subject.errors[:base]).to match_array [ 'ERROR: invalid userHash' ]
        end
      end
    end

    context 'when not all parameters are valid' do
      let(:minifig_number) { nil }
      let(:wanted) { true }

      it 'raises a ValidationError' do
        expect { update_minifig_collection }.to raise_error Brickset::ValidationError, "Minifig number can't be blank and Wanted is not included in the list"
      end
    end
  end
end
