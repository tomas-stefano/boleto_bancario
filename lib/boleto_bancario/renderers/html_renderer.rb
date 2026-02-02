# frozen_string_literal: true

module BoletoBancario
  module Renderers
    # Renderizador de boletos em formato HTML usando templates ERB.
    #
    # @example Gerando HTML com template padrão
    #
    #    boleto = BoletoBancario::Itau.new(...)
    #    html_content = BoletoBancario::Renderers::HtmlRenderer.new(boleto).render
    #
    # @example Customizando o caminho dos templates
    #
    #    class MyHtmlRenderer < BoletoBancario::Renderers::HtmlRenderer
    #      self.template_path = 'path/to/my/templates'
    #    end
    #
    #    renderer = MyHtmlRenderer.new(boleto)
    #    html = renderer.render
    #
    class HtmlRenderer < Base
      # Renderiza o boleto em HTML usando template ERB.
      #
      # @return [String] O conteúdo HTML do boleto
      #
      def render
        render_template('boleto.html.erb')
      end

      # Retorna os estilos CSS para o boleto.
      # Pode ser sobrescrito em subclasses para customização.
      #
      # @return [String]
      #
      def css_styles
        css_file = File.join(template_path, 'boleto_styles.css')
        if File.exist?(css_file)
          File.read(css_file)
        else
          default_css_styles
        end
      end

      # Retorna a lista de instruções não vazias.
      #
      # @return [Array<String>]
      #
      def instructions
        [
          boleto.instrucoes1,
          boleto.instrucoes2,
          boleto.instrucoes3,
          boleto.instrucoes4,
          boleto.instrucoes5,
          boleto.instrucoes6
        ].compact.reject(&:empty?)
      end

      # Retorna o nome do banco formatado.
      #
      # @return [String]
      #
      def bank_name
        boleto.class.name.split('::').last
      end

      private

      def default_css_styles
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
    end
  end
end
