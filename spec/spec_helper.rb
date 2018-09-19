require 'bundler/setup'
require 'webmock/rspec'
require 'shoulda-matchers'

require 'brickset'

RSpec.configure do |config|
  # Set a dummy API key for the specs.
  config.before do
    Brickset.configure do |c|
      c.api_key = 'super-secret'
    end
  end

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :active_model
  end
end

def stub_post(path)
  stub_request(:post, Brickset::BASE_URI + path)
end

def fixture_path
  File.expand_path('../fixtures', __FILE__)
end

def fixture(file)
  File.read(fixture_path + '/' + file)
end
