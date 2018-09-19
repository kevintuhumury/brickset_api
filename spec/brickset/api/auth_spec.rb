require 'spec_helper'

RSpec.describe Brickset::Client do
  let(:api_key) { Brickset.configuration.api_key }

  describe '#login' do
    let(:username) { 'darth-vader' }
    let(:password) { 'i-am-your-father' }

    context 'with valid credentials and API key' do
      before { stub_post('/login').with(body: "username=#{username}&password=#{password}&apiKey=#{api_key}").to_return body: fixture('login.xml') }

      it 'receives an user hash' do
        expect(subject.login(username, password)).to eq 'abc123!@#'
      end
    end

    context 'with invalid credentials' do
      let(:password) { 'invalid' }

      before { stub_post('/login').with(body: "username=#{username}&password=#{password}&apiKey=#{api_key}").to_return body: fixture('login_invalid_credentials.xml') }

      it 'receives an error response' do
        expect(subject.login(username, password)).to eq 'ERROR: invalid username and/or password'
      end
    end

    context 'with an invalid API key' do
      before do
        allow(Brickset).to receive(:configuration).and_return double(api_key: 'invalid')
        stub_post('/login').with(body: "username=#{username}&password=#{password}&apiKey=#{api_key}").to_return body: fixture('login_invalid_key.xml')
      end

      it 'receives an INVALIDKEY response' do
        expect(subject.login(username, password)).to eq 'INVALIDKEY'
      end
    end
  end

  describe '#valid_api_key?' do
    context 'with a valid API key' do
      before { stub_post('/checkKey').with(body: "apiKey=#{api_key}").to_return body: fixture('api_key_valid.xml') }

      it 'returns true' do
        expect(subject.valid_api_key?).to eq true
      end
    end

    context 'with an invalid API key' do
      before do
        allow(Brickset).to receive(:configuration).and_return double(api_key: 'invalid')
        stub_post('/checkKey').with(body: "apiKey=#{api_key}").to_return body: fixture('api_key_invalid.xml')
      end

      it 'returns false' do
        expect(subject.valid_api_key?).to eq false
      end
    end
  end

  describe '#valid_token?' do
    subject { described_class.new(token: token) }

    context 'with a valid token' do
      let(:token) { 'valid' }

      before { stub_post('/checkUserHash').with(body: "apiKey=#{api_key}&userHash=#{token}").to_return body: fixture('token_valid.xml') }

      it 'returns true' do
        expect(subject.valid_token?).to eq true
      end
    end

    context 'with an invalid token' do
      let(:token) { 'invalid' }

      before { stub_post('/checkUserHash').with(body: "apiKey=#{api_key}&userHash=#{token}").to_return body: fixture('token_invalid.xml') }

      it 'returns false' do
        expect(subject.valid_token?).to eq false
      end
    end
  end
end
