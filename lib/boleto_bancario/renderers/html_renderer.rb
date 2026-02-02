# frozen_string_literal: true

module BoletoBancario
  module Renderers
    # Renderizador de boletos em formato HTML.
    #
    # @example Gerando HTML
    #
    #    boleto = BoletoBancario::Itau.new(...)
    #    html_content = BoletoBancario::Renderers::HtmlRenderer.new(boleto).render
    #
    class HtmlRenderer < Base
      # Renderiza o boleto em HTML.
      #
      # @return [String] O conteúdo HTML do boleto
      #
      def render
        <<~HTML
          <!DOCTYPE html>
          <html lang="pt-BR">
          <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Boleto Bancário</title>
            <style>
              #{css_styles}
            </style>
          </head>
          <body>
            <div class="boleto">
              #{render_header}
              #{render_linha_digitavel}
              #{render_cedente_info}
              #{render_payment_info}
              #{render_sacado_info}
              #{render_instructions}
              #{render_barcode_section}
            </div>
          </body>
          </html>
        HTML
      end

      private

      def css_styles
        <<~CSS
          * { margin: 0; padding: 0; box-sizing: border-box; }
          body { font-family: Arial, sans-serif; font-size: 12px; }
          .boleto { max-width: 800px; margin: 20px auto; border: 1px solid #000; padding: 15px; }
          .header { display: flex; justify-content: space-between; border-bottom: 2px solid #000; padding-bottom: 10px; margin-bottom: 10px; }
          .bank-name { font-size: 18px; font-weight: bold; }
          .bank-code { font-size: 16px; font-weight: bold; }
          .linha-digitavel { text-align: center; font-size: 14px; font-weight: bold; margin: 15px 0; letter-spacing: 1px; }
          .info-row { display: flex; border-bottom: 1px solid #ccc; }
          .info-cell { flex: 1; padding: 5px; border-right: 1px solid #ccc; }
          .info-cell:last-child { border-right: none; }
          .info-cell label { font-size: 10px; color: #666; display: block; }
          .info-cell span { font-weight: bold; }
          .instructions { margin: 15px 0; padding: 10px; background: #f9f9f9; }
          .instructions h4 { margin-bottom: 5px; }
          .instructions ul { margin-left: 20px; }
          .barcode { text-align: center; margin: 20px 0; font-family: 'Libre Barcode 128', monospace; font-size: 48px; }
          .barcode-text { font-size: 10px; margin-top: 5px; }
        CSS
      end

      def render_header
        <<~HTML
          <div class="header">
            <div class="bank-name">#{boleto.class.name.demodulize}</div>
            <div class="bank-code">#{boleto.codigo_banco_formatado}</div>
          </div>
        HTML
      end

      def render_linha_digitavel
        <<~HTML
          <div class="linha-digitavel">#{linha_digitavel}</div>
        HTML
      end

      def render_cedente_info
        <<~HTML
          <div class="info-row">
            <div class="info-cell" style="flex: 2;">
              <label>Cedente</label>
              <span>#{boleto.cedente}</span>
            </div>
            <div class="info-cell">
              <label>CPF/CNPJ</label>
              <span>#{boleto.documento_cedente}</span>
            </div>
            <div class="info-cell">
              <label>Agência/Código Cedente</label>
              <span>#{boleto.agencia_codigo_cedente}</span>
            </div>
          </div>
        HTML
      end

      def render_payment_info
        <<~HTML
          <div class="info-row">
            <div class="info-cell">
              <label>Data Vencimento</label>
              <span>#{data_vencimento_formatada}</span>
            </div>
            <div class="info-cell">
              <label>Valor Documento</label>
              <span>R$ #{valor_formatado}</span>
            </div>
            <div class="info-cell">
              <label>Nosso Número</label>
              <span>#{nosso_numero}</span>
            </div>
            <div class="info-cell">
              <label>Nº Documento</label>
              <span>#{boleto.numero_documento}</span>
            </div>
          </div>
          <div class="info-row">
            <div class="info-cell">
              <label>Carteira</label>
              <span>#{boleto.carteira_formatada}</span>
            </div>
            <div class="info-cell">
              <label>Espécie</label>
              <span>#{boleto.especie_documento}</span>
            </div>
            <div class="info-cell">
              <label>Data Documento</label>
              <span>#{data_documento_formatada}</span>
            </div>
            <div class="info-cell">
              <label>Aceite</label>
              <span>#{boleto.aceite_formatado}</span>
            </div>
          </div>
        HTML
      end

      def render_sacado_info
        <<~HTML
          <div class="info-row">
            <div class="info-cell" style="flex: 2;">
              <label>Sacado</label>
              <span>#{boleto.sacado}</span>
            </div>
            <div class="info-cell">
              <label>CPF/CNPJ</label>
              <span>#{boleto.documento_sacado}</span>
            </div>
          </div>
        HTML
      end

      def render_instructions
        instructions = [
          boleto.instrucoes1,
          boleto.instrucoes2,
          boleto.instrucoes3,
          boleto.instrucoes4,
          boleto.instrucoes5,
          boleto.instrucoes6
        ].compact

        return '' if instructions.empty?

        <<~HTML
          <div class="instructions">
            <h4>Instruções</h4>
            <ul>
              #{instructions.map { |i| "<li>#{i}</li>" }.join}
            </ul>
          </div>
        HTML
      end

      def render_barcode_section
        <<~HTML
          <div class="barcode">
            <div class="barcode-text">#{codigo_de_barras}</div>
          </div>
        HTML
      end
    end
  end
end
