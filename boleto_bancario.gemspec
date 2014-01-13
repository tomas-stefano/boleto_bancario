# -*- encoding: utf-8 -*-
require File.expand_path('../lib/boleto_bancario/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Tomas D'Stefano"]
  gem.email         = ["tomas_stefano@successoft.com"]
  gem.description   = %q{Emissão de Boletos Bancários em Ruby}
  gem.summary       = %q{Emissão de Boletos Bancários em Ruby}
  gem.homepage      = "https://github.com/tomas-stefano/boleto_bancario"

  gem.files         = `git ls-files`.split($\).reject { |f| File.extname(f) == '.pdf' }
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "boleto_bancario"
  gem.require_paths = ["lib"]
  gem.version       = BoletoBancario::VERSION

  gem.add_dependency "rake"
  gem.add_dependency "activesupport", "~> 4.0.0"
  gem.add_dependency "activemodel", "~> 4.0.0"
  gem.add_dependency "barby"

  gem.add_development_dependency "rspec", "~> 2.13"
  gem.add_development_dependency "yard"
  gem.add_development_dependency "valid_attribute", "~> 1.3"
  gem.add_development_dependency "pry", "~> 0.9"
  gem.add_development_dependency "simplecov", "~> 0.2"
  gem.add_development_dependency "simplecov-html", "~> 0.7"
end
