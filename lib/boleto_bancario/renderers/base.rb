# frozen_string_literal: true

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

      protected

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
