lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'brickset/version'

Gem::Specification.new do |spec|
  spec.name          = 'brickset_api'
  spec.version       = Brickset::VERSION
  spec.authors       = ['Kevin Tuhumury']
  spec.email         = ['kevin.tuhumury@gmail.com']

  spec.summary       = %q{A Ruby wrapper around the Brickset.com (v2) API.}
  spec.description   = %q{This gem provides a Ruby wrapper around the Brickset.com (v2) API. The Brickset.com API responds with XML. This gem maps that into Ruby objects using Happymapper.}
  spec.homepage      = 'https://github.com/kevintuhumury/brickset_api'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'httparty', '~> 0.16'
  spec.add_runtime_dependency 'nokogiri-happymapper', '~> 0.8'
  spec.add_runtime_dependency 'activemodel', '>= 5.2'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'webmock', '~> 3.4'
  spec.add_development_dependency 'shoulda-matchers', '~> 3.1'
end
