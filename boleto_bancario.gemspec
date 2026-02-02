# frozen_string_literal: true

require_relative 'lib/boleto_bancario/version'

Gem::Specification.new do |gem|
  gem.authors       = ["Tomas D'Stefano"]
  gem.email         = ["tomas_stefano@successoft.com"]
  gem.description   = 'Emissão de Boletos Bancários em Ruby'
  gem.summary       = 'Emissão de Boletos Bancários em Ruby'
  gem.homepage      = 'https://github.com/tomas-stefano/boleto_bancario'
  gem.license       = 'MIT'

  gem.required_ruby_version = '>= 3.1.0'

  gem.files         = Dir['lib/**/*', 'LICENSE', 'README.markdown', 'Changelog.markdown']
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.require_paths = ['lib']
  gem.name          = 'boleto_bancario'
  gem.version       = BoletoBancario::VERSION

  gem.add_dependency 'activesupport', '~> 7.1'
  gem.add_dependency 'activemodel', '~> 7.1'
  gem.add_dependency 'barby', '~> 0.6'
  gem.add_dependency 'prawn', '~> 2.4'
  gem.add_dependency 'prawn-table', '~> 0.2'
  gem.add_dependency 'chunky_png', '~> 1.4'

  gem.add_development_dependency 'rake', '~> 13.0'
  gem.add_development_dependency 'rspec', '~> 3.13'
  gem.add_development_dependency 'yard', '~> 0.9'
  gem.add_development_dependency 'valid_attribute', '~> 2.0'
  gem.add_development_dependency 'pry', '~> 0.14'
  gem.add_development_dependency 'simplecov', '~> 0.22'
end
