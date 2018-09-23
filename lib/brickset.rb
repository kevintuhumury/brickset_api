require 'httparty'
require 'happymapper'
require 'active_model'
require 'active_support/all'

require 'brickset/version'
require 'brickset/configuration'

require 'brickset/elements/set'
require 'brickset/elements/year'
require 'brickset/elements/theme'
require 'brickset/elements/subtheme'
require 'brickset/elements/instruction'
require 'brickset/elements/additional_image'
require 'brickset/elements/review'
require 'brickset/elements/collection_detail'
require 'brickset/elements/collection_total'
require 'brickset/elements/minifig_collection'
require 'brickset/elements/user_note'
require 'brickset/elements/condition'

require 'brickset/api/auth'
require 'brickset/api/set'
require 'brickset/api/collection/set'
require 'brickset/api/collection/minifig'
require 'brickset/api/collection/advanced'

module Brickset
  ValidationError = Class.new(StandardError)

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
