# -*- encoding: utf-8 -*-
require File.expand_path('../lib/boleto_bancario/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Tomas D'Stefano"]
  gem.email         = ["tomas_stefano@successoft.com"]
  gem.description   = %q{Emissão de Boletos Bancários em Ruby}
  gem.summary       = %q{Emissão de Boletos Bancários em Ruby}
  gem.homepage      = "https://github.com/tomas-stefano/boleto_bancario"

  gem.files         = `git ls-files`.split($\).reject { |f| File.extname(f).downcase == '.pdf' }
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "boleto_bancario"
  gem.require_paths = ["lib"]
  gem.version       = BoletoBancario::VERSION

  gem.add_dependency "activesupport", "~> 3.2"
  gem.add_dependency "actionpack", "~> 3.2"
  gem.add_dependency "activemodel", "~> 3.2"
  gem.add_dependency "barby", "~> 0.5.1"
  gem.add_dependency "chunky_png", "~> 1.2.7"
  gem.add_development_dependency "rspec", "~> 2.11"
  gem.add_development_dependency "valid_attribute", "~> 1.3"
  gem.add_development_dependency "pry", "~> 0.9"
  gem.add_development_dependency "simplecov", "~> 0.2"
  gem.add_development_dependency "simplecov-html", "~> 0.7"
end
