# encoding: utf-8
require 'bundler/gem_tasks'
require 'yard'

desc 'Generate documentation'
YARD::Rake::YardocTask.new do |t|
  t.files   = ['lib/**/*.rb', '-', 'LICENSE']
  t.options = ['--main', 'README.markdown', '--no-private', '--title', "Boleto Bancário #{BoletoBancario::VERSION}"]
end