# encoding: utf-8
module BoletoBancario
  module Calculos
    # Classe responsável pelo cálculo de Fator de Vencimento do boleto bancário.
    #
    # === Descricão
    #
    # Conforme Carta-circular 002926 do Banco Central do Brasil, de 24/07/2000, recomenda-se a indicação do Fator de Vencimento no Código de Barras.
    # A partir de 02/04/2001, o Banco acolhedor/recebedor não será mais responsável por eventuais diferenças de recebimento de BOLETOs fora do prazo,
    # ou sem a indicação do fator de vencimento.
    #
    # === Forma para obtenção do Fator de Vencimento
    #
    # Calcula-se <b>o número de dias corridos</b> entre a data base (<b>“Fixada” em 07/10/1997</b>) e a do vencimento desejado:
    #
    #    Vencimento desejado:   04/07/2000
    #    Data base          : - 07/10/1997
    #    # => 1001
    #
    # === Atenção
    #
    # Caso ocorra divergência entre a data impressa no campo “data de vencimento” e a constante no código de barras,
    # o recebimento se dará da seguinte forma:
    #
    # * Quando pago por sistemas eletrônicos (Home-Banking, Auto-Atendimento, Internet, SISPAG, telefone, etc.), prevalecerá à representada no “código de barras”;
    # * Quando quitado na rede de agências, diretamente no caixa, será considerada a data impressa no campo “vencimento” do BOLETO.
    #
    # @return [String] retorna o resultado do cálculo. <b>Deve conter 4 dígitos</b>.
    #
    # @example
    #
    #    FatorVencimento.new(Date.parse("2012-12-02"))
    #    #=> "5535"
    #
    #    FatorVencimento.new(Date.parse("1997-10-08"))
    #    #=> "0001"
    #
    #    FatorVencimento.new(Date.parse("2012-12-16"))
    #    #=> "5549"
    #
    #    FatorVencimento.new(Date.parse("2014-12-15"))
    #    #=> "6278"
    #
    class FatorVencimento < String
      attr_reader :base_date
      # @param [Date] expiration_date
      # @param [Date] base_date
      # @return [String] retorna o resultado do cálculo. <b>Deve conter 4 dígitos</b>.
      # @example
      #    FatorVencimento.new(Date.parse("2012-09-02"))
      #    #=> "5444"
      #
      #    FatorVencimento.new(Date.parse("1999-10-01"))
      #    #=> "0724"
      #
      #    FatorVencimento.new(Date.parse("2022-12-16"))
      #    #=> "9201"
      #
      def initialize(expiration_date, base_date = Date.new(1997, 10, 7))
        @base_date       = base_date
        @expiration_date = expiration_date

        if @expiration_date.present?
          super(calculate)
        end
      end

      # Cálculo da data de vencimento com a data base.
      #
      # @return [String] exatamente 4 dígitos
      #
      def calculate
        expiration_date_minus_base_date.to_s.rjust(4, '0')
      end

      # @api private
      #
      # Cálculo da data de vencimento com a data base.
      # Chamando #to_i para não retornar um Float.
      # @return [Integer] diff between this two dates.
      #
      def expiration_date_minus_base_date
        (@expiration_date - @base_date).to_i
      end
    end
  end
end