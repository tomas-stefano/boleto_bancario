# frozen_string_literal: true

require 'prawn'
require 'prawn/table'
require 'barby'
require 'barby/barcode/code_25_interleaved'
require 'barby/outputter/prawn_outputter'

module BoletoBancario
  module Renderers
    # Renderizador de boletos em formato PDF usando Prawn.
    #
    # @example Gerando um PDF
    #
    #    boleto = BoletoBancario::Itau.new(...)
    #    pdf_content = BoletoBancario::Renderers::PdfRenderer.new(boleto).render
    #    File.write('boleto.pdf', pdf_content)
    #
    class PdfRenderer < Base
      # Configurações padrão do documento PDF.
      DEFAULT_OPTIONS = {
        page_size: 'A4',
        margin: [20, 20, 20, 20]
      }.freeze

      # Renderiza o boleto em PDF.
      #
      # @return [String] O conteúdo binário do PDF
      #
      def render
        Prawn::Document.new(**DEFAULT_OPTIONS) do |pdf|
          render_header(pdf)
          render_bank_info(pdf)
          pdf.move_down 10
          render_recipient_info(pdf)
          pdf.move_down 10
          render_payment_info(pdf)
          pdf.move_down 10
          render_barcode(pdf)
          pdf.move_down 20
          render_instructions(pdf)
          pdf.move_down 30
          render_tear_line(pdf)
          pdf.move_down 10
          render_stub(pdf)
        end.render
      end

      private

      def render_header(pdf)
        pdf.text boleto.class.name.demodulize, size: 14, style: :bold
        pdf.text "Código do Banco: #{boleto.codigo_banco_formatado}", size: 10
      end

      def render_bank_info(pdf)
        pdf.move_down 10
        pdf.text linha_digitavel, size: 12, style: :bold, align: :center
      end

      def render_recipient_info(pdf)
        data = [
          ['Cedente', boleto.cedente],
          ['CPF/CNPJ', boleto.documento_cedente],
          ['Endereço', boleto.endereco_cedente],
          ['Agência/Código Cedente', boleto.agencia_codigo_cedente]
        ]

        pdf.table(data, width: pdf.bounds.width) do |t|
          t.cells.borders = [:bottom]
          t.cells.padding = [2, 5]
          t.column(0).font_style = :bold
          t.column(0).width = 150
        end
      end

      def render_payment_info(pdf)
        data = [
          ['Data Vencimento', data_vencimento_formatada, 'Valor', "R$ #{valor_formatado}"],
          ['Nosso Número', nosso_numero, 'Nº Documento', boleto.numero_documento],
          ['Carteira', boleto.carteira_formatada, 'Espécie', boleto.especie_documento],
          ['Sacado', boleto.sacado, 'CPF/CNPJ', boleto.documento_sacado]
        ]

        pdf.table(data, width: pdf.bounds.width) do |t|
          t.cells.borders = [:bottom]
          t.cells.padding = [2, 5]
          t.columns([0, 2]).font_style = :bold
          t.columns([0, 2]).width = 100
        end
      end

      def render_barcode(pdf)
        barcode = Barby::Code25Interleaved.new(codigo_de_barras)
        outputter = Barby::PrawnOutputter.new(barcode)
        outputter.annotate_pdf(pdf, height: 40, x: 0)
      end

      def render_instructions(pdf)
        pdf.text 'Instruções:', style: :bold
        [
          boleto.instrucoes1,
          boleto.instrucoes2,
          boleto.instrucoes3,
          boleto.instrucoes4,
          boleto.instrucoes5,
          boleto.instrucoes6
        ].compact.each do |instrucao|
          pdf.text "• #{instrucao}", size: 9
        end
      end

      def render_tear_line(pdf)
        pdf.stroke_horizontal_rule
        pdf.text 'Corte aqui', size: 8, align: :center
        pdf.stroke_horizontal_rule
      end

      def render_stub(pdf)
        pdf.text 'RECIBO DO SACADO', size: 10, style: :bold
        pdf.move_down 5
        pdf.text "Cedente: #{boleto.cedente}", size: 9
        pdf.text "Sacado: #{boleto.sacado}", size: 9
        pdf.text "Valor: R$ #{valor_formatado}", size: 9
        pdf.text "Vencimento: #{data_vencimento_formatada}", size: 9
        pdf.text "Nosso Número: #{nosso_numero}", size: 9
      end
    end
  end
end
