# frozen_string_literal: true

require 'spec_helper'

module BoletoBancario
  module Renderers
    describe Base do
      let(:valid_boleto) do
        BoletoBancario::Itau.new(
          cedente: 'Empresa Exemplo LTDA',
          documento_cedente: '12.345.678/0001-90',
          endereco_cedente: 'Rua Exemplo, 123 - Centro - Sao Paulo/SP',
          sacado: 'Cliente Teste',
          documento_sacado: '123.456.789-00',
          data_vencimento: Date.new(2024, 12, 31),
          numero_documento: '12345678',
          valor_documento: 150.00,
          agencia: '0097',
          conta_corrente: '12345',
          carteira: '109',
          codigo_cedente: '12345'
        )
      end

      let(:invalid_boleto) do
        BoletoBancario::Itau.new
      end

      describe '#initialize' do
        context 'when boleto is valid' do
          it 'initializes successfully' do
            renderer = described_class.new(valid_boleto)
            expect(renderer.boleto).to eq valid_boleto
          end
        end

        context 'when boleto is invalid' do
          it 'raises ArgumentError' do
            expect { described_class.new(invalid_boleto) }.to raise_error(ArgumentError, 'Boleto deve ser válido')
          end
        end
      end

      describe '#render' do
        it 'raises NotImplementedError' do
          renderer = described_class.new(valid_boleto)
          expect { renderer.render }.to raise_error(NotImplementedError)
        end
      end

      describe '#to_partial_path' do
        it 'delegates to boleto' do
          renderer = described_class.new(valid_boleto)
          expect(renderer.to_partial_path).to eq valid_boleto.to_partial_path
        end
      end

      describe '.template_path' do
        after do
          described_class.template_path = nil
        end

        it 'defaults to nil' do
          expect(described_class.template_path).to be_nil
        end

        it 'can be set' do
          described_class.template_path = '/custom/path'
          expect(described_class.template_path).to eq '/custom/path'
        end
      end

      describe '#template_path (protected)' do
        let(:renderer) { described_class.new(valid_boleto) }

        after do
          described_class.template_path = nil
        end

        context 'when class template_path is not set' do
          it 'returns default template path' do
            expect(renderer.send(:template_path)).to include('lib/boleto_bancario/templates')
          end
        end

        context 'when class template_path is set' do
          it 'returns custom template path' do
            described_class.template_path = '/custom/templates'
            expect(renderer.send(:template_path)).to eq '/custom/templates'
          end
        end
      end

      describe '#default_template_path (protected)' do
        let(:renderer) { described_class.new(valid_boleto) }

        it 'returns the bundled templates path' do
          path = renderer.send(:default_template_path)
          expect(path).to end_with('lib/boleto_bancario/templates')
          expect(File.directory?(path)).to be true
        end
      end

      describe '#render_template (protected)' do
        # Use HtmlRenderer since it provides the methods templates need
        let(:renderer) { HtmlRenderer.new(valid_boleto) }

        it 'renders an ERB template' do
          result = renderer.send(:render_template, 'boleto.html.erb')
          expect(result).to include('<!DOCTYPE html>')
          expect(result).to include('Boleto Bancario')
        end

        it 'raises error for non-existent template' do
          expect { renderer.send(:render_template, 'non_existent.erb') }.to raise_error(Errno::ENOENT)
        end
      end

      describe '#render_partial (protected)' do
        # Use HtmlRenderer since it provides the methods templates need
        let(:renderer) { HtmlRenderer.new(valid_boleto) }

        it 'renders a partial template with underscore prefix' do
          result = renderer.send(:render_partial, 'header')
          expect(result).to include('bank-name')
          expect(result).to include('bank-code')
        end
      end

      describe '#locals (protected)' do
        let(:renderer) { described_class.new(valid_boleto) }

        it 'returns a hash with boleto and renderer' do
          locals = renderer.send(:locals)
          expect(locals).to be_a(Hash)
          expect(locals[:boleto]).to eq valid_boleto
          expect(locals[:renderer]).to eq renderer
        end
      end

      describe 'protected helper methods' do
        let(:renderer) { described_class.new(valid_boleto) }

        describe '#codigo_de_barras' do
          it 'delegates to boleto' do
            expect(renderer.send(:codigo_de_barras)).to eq valid_boleto.codigo_de_barras
          end
        end

        describe '#linha_digitavel' do
          it 'delegates to boleto' do
            expect(renderer.send(:linha_digitavel)).to eq valid_boleto.linha_digitavel
          end
        end

        describe '#nosso_numero' do
          it 'delegates to boleto' do
            expect(renderer.send(:nosso_numero)).to eq valid_boleto.nosso_numero
          end
        end

        describe '#valor_formatado' do
          it 'formats value with comma as decimal separator' do
            expect(renderer.send(:valor_formatado)).to eq '150,00'
          end
        end

        describe '#data_vencimento_formatada' do
          it 'formats date as dd/mm/yyyy' do
            expect(renderer.send(:data_vencimento_formatada)).to eq '31/12/2024'
          end
        end

        describe '#data_documento_formatada' do
          it 'formats date as dd/mm/yyyy' do
            expect(renderer.send(:data_documento_formatada)).to eq Date.today.strftime('%d/%m/%Y')
          end
        end
      end
    end
  end
end
