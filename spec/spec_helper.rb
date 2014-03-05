require 'bundler/setup'
Bundler.require(:default, :development)

Dir[File.join(File.dirname(__FILE__), 'shared_examples/**/*.rb')].each do |file|
  require(file)
end

if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.formatter = SimpleCov::Formatter::HTMLFormatter
  SimpleCov.start do
    add_filter "/spec/"
  end
end