# frozen_string_literal: true

require 'bundler/setup'
Bundler.require(:default, :development)

Dir[File.join(File.dirname(__FILE__), 'shared_examples/**/*.rb')].each do |file|
  require(file)
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.filter_run_when_matching :focus
  config.example_status_persistence_file_path = 'spec/examples.txt'
  config.warnings = true

  config.default_formatter = 'doc' if config.files_to_run.one?

  config.order = :random
  Kernel.srand config.seed
end

if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.formatter = SimpleCov::Formatter::HTMLFormatter
  SimpleCov.start do
    add_filter '/spec/'
    enable_coverage :branch
  end
end
