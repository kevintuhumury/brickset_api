require 'spec_helper'

RSpec.describe Brickset do
  it 'has a version number' do
    expect(Brickset::VERSION).not_to be_nil
  end

  it 'knows its base URI' do
    expect(Brickset::BASE_URI).to eq 'https://brickset.com/api/v2.asmx'
  end

  describe '.client' do
    context 'when the options hash is specified' do
      it 'instantiates a new instance with the specified options' do
        expect(Brickset::Client).to receive(:new).with token: 'access-token'
        described_class.client(token: 'access-token')
      end
    end

    context 'when no options have been specified' do
      it 'instantiates a new instance withouth any options' do
        expect(Brickset::Client).to receive(:new).with({})
        described_class.client
      end
    end
  end

  describe '.login' do
    it 'calls #login on the Brickset::Client instance' do
      expect_any_instance_of(Brickset::Client).to receive(:login).with 'darth-vader', 'i-am-your-father'
      described_class.login('darth-vader', 'i-am-your-father')
    end
  end

  describe '.configure' do
    before do
      Brickset.configure do |config|
        config.api_key = 'super-secret'
      end
    end

    it 'sets the api key' do
      expect(Brickset.configuration.api_key).to eq 'super-secret'
    end
  end

  describe '.reset' do
    before do
      Brickset.configure do |config|
        config.api_key = 'super-secret'
      end
    end

    it 'resets the configuration' do
      Brickset.reset
      expect(Brickset.configuration.api_key).to be_nil
    end
  end
end
