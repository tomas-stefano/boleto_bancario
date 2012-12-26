module BoletoBancario
  module Calculos
    # Classe que possue a convenção de calculo do modulo 11.
    # O que muda para cada classe é a forma de verificar o total do cálculo.
    #
    # @abstract Precisa implementar { #fatores, #calculate } nas subclasses.
    #
    class Modulo11 < String
      # Número que será feito o cálculo do módulo 11.
      #
      attr_reader :number

      # @param [String ou Integer] number (Corresponde ao número a ser calculado pelo Módulo 11)
      # @return [String]
      #
      def initialize(number)
        @number  = number

        super(calculate.to_s)
      end

      # @return [Array] Fatores que serão multiplicados por cada digito do
      # número passado como argumento no initialize.
      # @raise [NotImplementedError] Precisa implementar na subclasse
      #
      def fatores
        raise NotImplementedError, "Not implemented #fatores in subclass."
      end

      # @return [Fixnum]
      # @raise [NotImplementedError] Precisa implementar na subclasse
      #
      def calculate
        raise NotImplementedError, "Not implemented #calculate in subclass."
      end

      # Realiza o cálculo retornando o resto da divisão do cálculo dos fatores por 11.
      #
      # @return [Fixnum] Resto da divisão por 11.
      #
      def mod_division
        @mod_division ||= FatoresDeMultiplicacao.new(@number, fatores: fatores).sum % 11
      end

      # Subtrai 11 do resto da divisão para se ter o total do módulo 11.
      #
      # @return [Fixnum]
      #
      def total
        @total ||= 11 - mod_division
      end
    end
  end
end