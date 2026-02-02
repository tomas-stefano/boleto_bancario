# frozen_string_literal: true

require 'spec_helper'

module BoletoBancario
  module Renderers
    describe HtmlRenderer do
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

      let(:boleto_with_instructions) do
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
          codigo_cedente: '12345',
          instrucoes1: 'Nao receber apos vencimento',
          instrucoes2: 'Juros de 1% ao mes',
          instrucoes3: 'Multa de 2% apos vencimento'
        )
      end

      let(:renderer) { described_class.new(valid_boleto) }

      describe '#render' do
        subject(:html) { renderer.render }

        it 'returns an HTML document' do
          expect(html).to include('<!DOCTYPE html>')
          expect(html).to include('<html lang="pt-BR">')
          expect(html).to include('</html>')
        end

        it 'includes the title' do
          expect(html).to include('<title>Boleto Bancario</title>')
        end

        it 'includes CSS styles' do
          expect(html).to include('<style>')
          expect(html).to include('.boleto')
        end

        it 'includes the header partial' do
          expect(html).to include('class="header"')
          expect(html).to include('class="bank-name"')
          expect(html).to include('class="bank-code"')
        end

        it 'includes the linha digitavel' do
          expect(html).to include('class="linha-digitavel"')
          expect(html).to include(valid_boleto.linha_digitavel.to_s)
        end

        it 'includes cedente information' do
          expect(html).to include('Cedente')
          expect(html).to include('Empresa Exemplo LTDA')
          expect(html).to include('12.345.678/0001-90')
        end

        it 'includes payment information' do
          expect(html).to include('Data Vencimento')
          expect(html).to include('31/12/2024')
          expect(html).to include('Valor Documento')
          expect(html).to include('R$ 150,00')
          expect(html).to include('Nosso Numero')
        end

        it 'includes sacado information' do
          expect(html).to include('Sacado')
          expect(html).to include('Cliente Teste')
          expect(html).to include('123.456.789-00')
        end

        it 'includes barcode section' do
          expect(html).to include('class="barcode"')
          expect(html).to include('barcode-text')
        end
      end

      describe '#render with instructions' do
        subject(:html) { described_class.new(boleto_with_instructions).render }

        it 'includes instructions section' do
          expect(html).to include('class="instructions"')
          expect(html).to include('Instrucoes')
        end

        it 'includes all instruction texts' do
          expect(html).to include('Nao receber apos vencimento')
          expect(html).to include('Juros de 1% ao mes')
          expect(html).to include('Multa de 2% apos vencimento')
        end
      end

      describe '#render without instructions' do
        subject(:html) { renderer.render }

        it 'does not include instructions section' do
          expect(html).not_to include('class="instructions"')
          expect(html).not_to include('Instrucoes')
        end
      end

      describe '#css_styles' do
        it 'returns CSS styles' do
          styles = renderer.css_styles
          expect(styles).to include('.boleto')
          expect(styles).to include('.header')
          expect(styles).to include('.info-row')
        end

        context 'when CSS file exists in template path' do
          it 'reads from the CSS file' do
            styles = renderer.css_styles
            expect(styles).to include('box-sizing: border-box')
          end
        end
      end

      describe '#instructions' do
        context 'without instructions' do
          it 'returns empty array' do
            expect(renderer.instructions).to eq([])
          end
        end

        context 'with instructions' do
          let(:renderer) { described_class.new(boleto_with_instructions) }

          it 'returns array of non-empty instructions' do
            expect(renderer.instructions).to eq([
              'Nao receber apos vencimento',
              'Juros de 1% ao mes',
              'Multa de 2% apos vencimento'
            ])
          end
        end

        context 'with some empty instructions' do
          let(:boleto_with_empty_instructions) do
            BoletoBancario::Itau.new(
              cedente: 'Empresa Exemplo LTDA',
              documento_cedente: '12.345.678/0001-90',
              endereco_cedente: 'Rua Exemplo, 123',
              sacado: 'Cliente Teste',
              documento_sacado: '123.456.789-00',
              data_vencimento: Date.new(2024, 12, 31),
              numero_documento: '12345678',
              valor_documento: 150.00,
              agencia: '0097',
              conta_corrente: '12345',
              carteira: '109',
              codigo_cedente: '12345',
              instrucoes1: 'Instrucao 1',
              instrucoes2: '',
              instrucoes3: 'Instrucao 3'
            )
          end
          let(:renderer) { described_class.new(boleto_with_empty_instructions) }

          it 'filters out empty instructions' do
            expect(renderer.instructions).to eq(['Instrucao 1', 'Instrucao 3'])
          end
        end
      end

      describe '#bank_name' do
        it 'returns the bank class name' do
          expect(renderer.bank_name).to eq('Itau')
        end
      end

      describe 'custom template path' do
        let(:custom_renderer_class) do
          Class.new(HtmlRenderer) do
            self.template_path = File.expand_path('../../../lib/boleto_bancario/templates', __dir__)
          end
        end

        after do
          # Reset the parent class template_path
          HtmlRenderer.template_path = nil
        end

        it 'uses custom template path' do
          renderer = custom_renderer_class.new(valid_boleto)
          html = renderer.render
          expect(html).to include('<!DOCTYPE html>')
        end
      end

      describe 'template inheritance' do
        it 'inherits template_path from parent class' do
          subclass = Class.new(HtmlRenderer)
          expect(subclass.template_path).to be_nil
        end

        it 'subclass can have its own template_path' do
          subclass = Class.new(HtmlRenderer)
          subclass.template_path = '/custom/path'
          expect(subclass.template_path).to eq('/custom/path')
          expect(HtmlRenderer.template_path).to be_nil
        end
      end

      describe 'integration with Boleto#to_html' do
        it 'generates HTML through boleto instance' do
          html = valid_boleto.to_html
          expect(html).to include('<!DOCTYPE html>')
          expect(html).to include('Empresa Exemplo LTDA')
        end
      end
    end
  end
end
