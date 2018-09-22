require 'spec_helper'

RSpec.describe Brickset::Client do
  it 'knows its ancestors' do
    aggregate_failures do
      expect(described_class.ancestors).to include HTTParty
      expect(described_class.ancestors).to include ActiveModel::Validations

      expect(described_class.ancestors).to include Brickset::Api::Auth
      expect(described_class.ancestors).to include Brickset::Api::Collection::Set
      expect(described_class.ancestors).to include Brickset::Api::Collection::Minifig
      expect(described_class.ancestors).to include Brickset::Api::Collection::Advanced
    end
  end

  it 'knows its base_uri' do
    expect(described_class.base_uri).to eq 'https://brickset.com/api/v2.asmx'
  end

  describe '#initialize' do
    context 'when a token is specified' do
      subject { described_class.new(token: 'access-token') }

      it 'sets the token attribute' do
        expect(subject.token).to eq 'access-token'
      end
    end

    context 'when no token is specified' do
      subject { described_class.new }

      it 'does not set the token attribute' do
        expect(subject.token).to be_nil
      end
    end
  end

  describe '#call' do
    let(:options) do
      {}
    end
    let(:body) { 'apiKey=super-secret' }
    let(:call) { subject.send(:call, '/method', options) }

    before { stub_post('/method').with(body: body).to_return body: fixture('api_key_valid.xml') }

    context 'when additional options have been set' do
      let(:options) do
        { attribute: 'value' }
      end

      let(:body) { 'attribute=value&apiKey=super-secret' }

      it 'makes a POST request with the additional options and default options as the body' do
        expect(described_class).to receive(:post).with('/method', { body: { attribute: 'value', apiKey: 'super-secret' } }).and_call_original
        call
      end
    end

    context 'when no additional options have been set' do
      it 'makes a POST request with the default options as the body' do
        expect(described_class).to receive(:post).with('/method', { body: { apiKey: 'super-secret' } }).and_call_original
        call
      end
    end

    context 'when the response is OK' do
      it 'returns the response body' do
        expect(call).to eq "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<string xmlns=\"https://brickset.com/api/\">OK</string>\n"
      end
    end

    context 'when the response is not OK' do
      before { stub_post('/method').with(body: body).to_return body: 'Error 500: Internal Server Error', status: 500 }

      it 'raises the response body' do
        expect { call }.to raise_error 'Error 500: Internal Server Error'
      end
    end
  end

  describe '#handle_update' do
    let(:handle_update) { subject.send(:handle_update, response) }

    let(:response) { fixture('api_key_valid.xml') }

    it 'parses the specified response' do
      expect(HappyMapper).to receive(:parse).with(response).and_call_original
      handle_update
    end

    context 'when the content is OK' do
      it 'returns true' do
        expect(handle_update).to eq true
      end
    end

    context 'when the content is not OK' do
      let(:response) { fixture('api_key_invalid.xml') }

      it 'saves a reference to the error' do
        handle_update
        expect(subject.errors[:base]).to match_array [ 'INVALIDKEY' ]
      end

      it 'returns false' do
        expect(handle_update).to eq false
      end
    end
  end

  describe '#extract_attributes_from_options' do
    let(:extract_attributes_from_options) { subject.send(:extract_attributes_from_options, options) }

    context 'when there is a known attribute in the options hash' do
      let(:options) do
        { owned: 0 }
      end

      it 'sets its value to the known attribute' do
        extract_attributes_from_options
        expect(subject.owned).to eq 0
      end
    end

    context 'when there is an unknown attribute in the options hash' do
      let(:options) do
        { unknown: 'value' }
      end

      it 'raises a KeyError' do
        expect { extract_attributes_from_options }.to raise_error KeyError, "Attribute key 'unknown' is not supported"
      end
    end
  end

  describe '#default_options' do
    let(:default_options) { subject.send(:default_options) }

    context 'when the token has not been set' do
      it 'knows its default options' do
        expect(default_options).to eq apiKey: 'super-secret'
      end
    end

    context 'when the token has been set' do
      subject { described_class.new(token: 'access-token') }

      it 'knows its default options' do
        expect(default_options).to eq apiKey: 'super-secret', userHash: 'access-token'
      end
    end
  end
end
