# frozen_string_literal: true

require 'spec_helper'
require 'fileutils'
require 'tmpdir'

# Only run these specs if Rails generators are available
begin
  require 'rails/generators'
  require 'generators/boleto_bancario/views_generator'

  module BoletoBancario
    module Generators
      describe ViewsGenerator do
        let(:destination_root) { Dir.mktmpdir }

        before do
          # Set destination root for generator
          ViewsGenerator.instance_variable_set(:@destination_root_cache, destination_root)
        end

        after do
          FileUtils.rm_rf(destination_root)
        end

        describe '.source_root' do
          it 'points to the templates directory' do
            expect(ViewsGenerator.source_root).to end_with('lib/boleto_bancario/templates')
          end

          it 'contains the template files' do
            source_path = ViewsGenerator.source_root
            expect(File.exist?(File.join(source_path, 'boleto.html.erb'))).to be true
            expect(File.exist?(File.join(source_path, 'boleto_styles.css'))).to be true
            expect(File.exist?(File.join(source_path, '_header.html.erb'))).to be true
            expect(File.exist?(File.join(source_path, '_cedente.html.erb'))).to be true
            expect(File.exist?(File.join(source_path, '_sacado.html.erb'))).to be true
            expect(File.exist?(File.join(source_path, '_payment.html.erb'))).to be true
            expect(File.exist?(File.join(source_path, '_instructions.html.erb'))).to be true
            expect(File.exist?(File.join(source_path, '_barcode.html.erb'))).to be true
          end
        end

        describe '.desc' do
          it 'has a description' do
            expect(ViewsGenerator.desc).to include('Copia os templates de boleto')
          end
        end
      end
    end
  end
rescue LoadError
  # Skip generator specs if Rails is not available
  RSpec.describe 'ViewsGenerator' do
    it 'requires Rails to test the generator' do
      skip 'Rails generators not available'
    end
  end
end
