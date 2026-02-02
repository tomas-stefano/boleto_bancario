# frozen_string_literal: true

require 'erb'

module BoletoBancario
  module Renderers
    # Classe base para renderizadores de boletos.
    #
    # Esta classe fornece a interface comum para todos os renderizadores
    # (PDF, HTML, PNG).
    #
    # @abstract Subclasses devem implementar o método #render
    #
    class Base
      attr_reader :boleto

      class << self
        # Caminho customizado para templates ERB.
        # Se não definido, usa o caminho padrão dos templates bundled.
        #
        # @return [String, nil]
        #
        attr_accessor :template_path
      end

      # Inicializa o renderizador com um boleto.
      #
      # @param [BoletoBancario::Core::Boleto] boleto O boleto a ser renderizado
      # @raise [ArgumentError] Se o boleto não for válido
      #
      def initialize(boleto)
        raise ArgumentError, 'Boleto deve ser válido' unless boleto.valid?

        @boleto = boleto
      end

      # Renderiza o boleto.
      #
      # @abstract Subclasses devem implementar este método
      # @raise [NotImplementedError]
      #
      def render
        raise NotImplementedError, "#{self.class} deve implementar #render"
      end

      # Retorna o partial path para integração com Rails.
      #
      # @return [String]
      #
      def to_partial_path
        boleto.to_partial_path
      end

      protected

      # Retorna o caminho para os templates.
      # Usa o template_path da classe se definido, caso contrário usa o padrão.
      #
      # @return [String]
      #
      def template_path
        self.class.template_path || default_template_path
      end

      # Retorna o caminho padrão para os templates bundled.
      #
      # @return [String]
      #
      def default_template_path
        File.expand_path('../templates', __dir__)
      end

      # Renderiza um template ERB.
      #
      # @param [String] template_name Nome do arquivo de template (ex: 'boleto.html.erb')
      # @return [String] Conteúdo renderizado
      #
      def render_template(template_name)
        template_file = File.join(template_path, template_name)
        template_content = File.read(template_file)
        erb = ERB.new(template_content, trim_mode: '-')
        erb.result(binding)
      end

      # Renderiza um partial ERB.
      #
      # @param [String] partial_name Nome do partial (sem underscore, ex: 'header')
      # @return [String] Conteúdo renderizado
      #
      def render_partial(partial_name)
        render_template("_#{partial_name}.html.erb")
      end

      # Retorna as variáveis locais disponíveis nos templates.
      #
      # @return [Hash]
      #
      def locals
        {
          boleto: boleto,
          renderer: self
        }
      end

      # Retorna o código de barras do boleto.
      #
      # @return [String]
      #
      def codigo_de_barras
        boleto.codigo_de_barras
      end

      # Retorna a linha digitável do boleto.
      #
      # @return [String]
      #
      def linha_digitavel
        boleto.linha_digitavel
      end

      # Retorna o nosso número formatado.
      #
      # @return [String]
      #
      def nosso_numero
        boleto.nosso_numero
      end

      # Retorna o valor formatado.
      #
      # @return [String]
      #
      def valor_formatado
        format('%.2f', boleto.valor_documento).tr('.', ',')
      end

      # Retorna a data de vencimento formatada.
      #
      # @return [String]
      #
      def data_vencimento_formatada
        boleto.data_vencimento.strftime('%d/%m/%Y')
      end

      # Retorna a data do documento formatada.
      #
      # @return [String]
      #
      def data_documento_formatada
        boleto.data_documento&.strftime('%d/%m/%Y')
      end
    end
  end
end
