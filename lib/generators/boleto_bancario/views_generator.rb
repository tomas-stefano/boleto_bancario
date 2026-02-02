# frozen_string_literal: true

require 'rails/generators'

module BoletoBancario
  module Generators
    # Rails generator para copiar os templates de boleto para a aplicacao Rails.
    #
    # @example Uso
    #   rails generate boleto_bancario:views
    #
    # Isso copia os templates padrao para app/views/boletos/, permitindo
    # customizacao completa dos templates de boleto.
    #
    class ViewsGenerator < Rails::Generators::Base
      desc 'Copia os templates de boleto para app/views/boletos/'

      source_root File.expand_path('../../boleto_bancario/templates', __dir__)

      def copy_templates
        directory '.', 'app/views/boletos'
      end

      def show_readme
        say ''
        say 'Templates copiados para app/views/boletos/', :green
        say ''
        say 'Arquivos criados:'
        say '  app/views/boletos/boleto.html.erb      - Template principal'
        say '  app/views/boletos/boleto_styles.css    - Estilos CSS'
        say '  app/views/boletos/_header.html.erb     - Partial do cabecalho'
        say '  app/views/boletos/_cedente.html.erb    - Partial do cedente'
        say '  app/views/boletos/_sacado.html.erb     - Partial do sacado'
        say '  app/views/boletos/_payment.html.erb    - Partial de pagamento'
        say '  app/views/boletos/_instructions.html.erb - Partial de instrucoes'
        say '  app/views/boletos/_barcode.html.erb    - Partial do codigo de barras'
        say ''
        say 'Para usar os templates customizados, configure o renderer:'
        say ''
        say '  class MyHtmlRenderer < BoletoBancario::Renderers::HtmlRenderer'
        say "    self.template_path = Rails.root.join('app/views/boletos')"
        say '  end'
        say ''
      end
    end
  end
end
