module Brickset
  class Client
    include HTTParty
    include ActiveModel::Validations

    include Brickset::Api::Auth
    include Brickset::Api::Collection::Minifig
    include Brickset::Api::Collection::Advanced

    base_uri Brickset::BASE_URI

    attr_reader :token

    def initialize(options = {})
      @token = options[:token] if options.key?(:token)
    end

    private

    def call(method, options = {})
      response = self.class.post(method, { body: options.merge(default_options) })

      if response.code == 200
        response.body
      else
        raise response.body
      end
    end

    def handle_update(response)
      content = HappyMapper.parse(response).content

      if content == 'OK'
        true
      else
        errors.add(:base, content)
        false
      end
    end

    def extract_attributes_from_options(options)
      options.each do |key, value|
        raise KeyError, "Attribute key '#{key}' is not supported" unless respond_to?("#{key}=")
        send("#{key}=", value)
      end
    end

    def default_options
      options = { apiKey: Brickset.configuration.api_key }
      options.merge!(userHash: token) if token
      options
    end
  end
end
