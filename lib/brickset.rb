require 'httparty'
require 'happymapper'

require 'brickset/version'
require 'brickset/configuration'

require 'brickset/api/auth'

module Brickset
  BASE_URI = 'https://brickset.com/api/v2.asmx'.freeze

  class << self
    attr_accessor :configuration

    def client(options = {})
      Brickset::Client.new(options)
    end

    def login(username, password)
      client.login(username, password)
    end

    def configure
      self.configuration ||= Configuration.new
      yield(configuration)
    end

    def reset
      self.configuration = Configuration.new
    end
  end
end

require 'brickset/client'
