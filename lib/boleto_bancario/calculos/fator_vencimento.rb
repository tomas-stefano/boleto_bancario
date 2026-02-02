# frozen_string_literal: true

module BoletoBancario
  module Calculos
    # Classe responsável pelo cálculo de Fator de Vencimento do boleto bancário.
    #
    # === Descrição
    #
    # Conforme Carta-circular 002926 do Banco Central do Brasil, de 24/07/2000, recomenda-se a indicação do Fator de Vencimento no Código de Barras.
    # A partir de 02/04/2001, o Banco acolhedor/recebedor não será mais responsável por eventuais diferenças de recebimento de BOLETOs fora do prazo,
    # ou sem a indicação do fator de vencimento.
    #
    # === Atualização FEBRABAN 2025
    #
    # Em 22/02/2025, o fator de vencimento atingiu o limite de 9999 (baseado em 07/10/1997).
    # A partir desta data, o cálculo utiliza uma nova data base (29/05/2022) e reinicia em 1000.
    #
    # === Forma para obtenção do Fator de Vencimento
    #
    # Calcula-se <b>o número de dias corridos</b> entre a data base e a do vencimento desejado:
    #
    # Para datas anteriores a 22/02/2025:
    #    Data base: 07/10/1997
    #    Vencimento: 04/07/2000 => Fator: 1001
    #
    # Para datas a partir de 22/02/2025:
    #    Data base: 29/05/2022
    #    Fator inicial: 1000
    #    Vencimento: 22/02/2025 => Fator: 1000
    #
    # === Atenção
    #
    # Caso ocorra divergência entre a data impressa no campo "data de vencimento" e a constante no código de barras,
    # o recebimento se dará da seguinte forma:
    #
    # * Quando pago por sistemas eletrônicos (Home-Banking, Auto-Atendimento, Internet, SISPAG, telefone, etc.), prevalecerá à representada no "código de barras";
    # * Quando quitado na rede de agências, diretamente no caixa, será considerada a data impressa no campo "vencimento" do BOLETO.
    #
    # @return [String] retorna o resultado do cálculo. <b>Deve conter 4 dígitos</b>.
    #
    # @example Datas anteriores à transição
    #
    #    FatorVencimento.new(Date.parse("2012-12-02"))
    #    #=> "5535"
    #
    #    FatorVencimento.new(Date.parse("1997-10-08"))
    #    #=> "0001"
    #
    # @example Datas após a transição FEBRABAN 2025
    #
    #    FatorVencimento.new(Date.parse("2025-02-21"))
    #    #=> "9999"
    #
    #    FatorVencimento.new(Date.parse("2025-02-22"))
    #    #=> "1000"
    #
    #    FatorVencimento.new(Date.parse("2025-02-23"))
    #    #=> "1001"
    #
    class FatorVencimento < String
      # Data base original utilizada até 21/02/2025
      OLD_BASE_DATE = Date.new(1997, 10, 7).freeze

      # Nova data base utilizada a partir de 22/02/2025
      NEW_BASE_DATE = Date.new(2022, 5, 29).freeze

      # Data de transição para o novo cálculo
      TRANSITION_DATE = Date.new(2025, 2, 22).freeze

      # Fator inicial para a nova data base
      NEW_BASE_FACTOR = 1000

      attr_reader :base_date

      # @param [Date] expiration_date Data de vencimento do boleto
      # @param [Date] base_date Data base para cálculo (opcional, determinado automaticamente)
      # @return [String] retorna o resultado do cálculo. <b>Deve conter 4 dígitos</b>.
      #
      # @example
      #    FatorVencimento.new(Date.parse("2025-03-01"))
      #    #=> "1007"
      #
      def initialize(expiration_date, base_date = nil)
        @expiration_date = expiration_date
        @base_date = base_date || determine_base_date

        if @expiration_date.present?
          super(calculate)
        else
          super()
        end
      end

      # Cálculo da data de vencimento com a data base.
      # Para ambos os períodos, o fator é simplesmente o número de dias desde a data base.
      # A nova data base (29/05/2022) foi escolhida para que 22/02/2025 resulte em fator 1000.
      #
      # @return [String] exatamente 4 dígitos
      #
      def calculate
        days_from_base.to_s.rjust(4, '0')
      end

      private

      # Determina qual data base usar com base na data de vencimento
      #
      # @return [Date] a data base apropriada
      #
      def determine_base_date
        return OLD_BASE_DATE unless @expiration_date

        uses_new_calculation? ? NEW_BASE_DATE : OLD_BASE_DATE
      end

      # Verifica se deve usar o novo cálculo (pós-transição FEBRABAN)
      #
      # @return [Boolean]
      #
      def uses_new_calculation?
        @expiration_date.is_a?(Date) && @expiration_date >= TRANSITION_DATE
      end

      # Calcula a diferença em dias entre a data de vencimento e a data base.
      # Chamando #to_i para não retornar um Float.
      #
      # @return [Integer] diferença em dias
      #
      def days_from_base
        (@expiration_date - @base_date).to_i
      end
    end
  end
end