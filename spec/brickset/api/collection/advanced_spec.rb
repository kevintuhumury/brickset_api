require 'spec_helper'

RSpec.describe Brickset::Client, type: :model do
  let(:api_key) { Brickset.configuration.api_key }
  let(:token)   { 'valid' }

  subject { described_class.new(token: token) }

  describe 'validations' do
    it { is_expected.to validate_inclusion_of(:condition).in_array(%w(acquired now)).on :collection_detail_conditions }
  end

  describe 'getCollectionDetail' do
    context 'with valid parameters' do
      before { stub_post('/getCollectionDetail').with(body: "setID=26907&apiKey=#{api_key}&userHash=#{token}").to_return body: fixture('get_collection_detail.xml') }

      it 'receives the collection detail' do
        expect(subject.collection_detail(26907)).to be_a Brickset::Elements::CollectionDetail
      end
    end

    context 'with an invalid parameter' do
      before do
        stub_post('/getCollectionDetail').with(body: "setID=non-existent&apiKey=#{api_key}&userHash=#{token}").to_return body: fixture('get_collection_detail_no_result.xml')
      end

      it 'does not receive any collection detail' do
        expect(subject.collection_detail('non-existent')).to be_nil
      end
    end
  end

  describe 'getCollectionDetailConditions' do
    context 'with a valid condition' do
      before do
        stub_post('/getCollectionDetailConditions').with(body: "which=acquired&apiKey=#{api_key}&userHash=#{token}").to_return body: fixture('get_collection_detail_conditions.xml')
      end

      it 'receives the collection detail conditions' do
        expect(subject.collection_detail_conditions('acquired')).to match_array [
          an_instance_of(Brickset::Elements::Condition),
          an_instance_of(Brickset::Elements::Condition),
          an_instance_of(Brickset::Elements::Condition),
          an_instance_of(Brickset::Elements::Condition),
          an_instance_of(Brickset::Elements::Condition),
          an_instance_of(Brickset::Elements::Condition),
          an_instance_of(Brickset::Elements::Condition)
        ]
      end
    end

    context 'with an invalid condition' do
      it 'raises a ValidationError' do
        expect { subject.collection_detail_conditions('invalid-condition') }.to raise_error Brickset::ValidationError, 'Condition is not included in the list'
      end
    end
  end

end
