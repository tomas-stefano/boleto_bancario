# encoding: utf-8
module BoletoBancario
  module Calculos
    # === Cálculo do Modulo 10
    #
    # === Passos
    #
    # 1) Multiplica-se cada algarismo do campo pela seqüência de multiplicadores <b>2, 1, 2, 1, 2, 1 ...</b>, posicionados da direita para a esquerda.
    #
    # 2) Some individualmente, os algarismos dos resultados dos produtos, obtendo-se o total (N).
    #
    # 3) Divida o total encontrado (N) por 10, e determine o resto da divisão como MOD 10 (N).
    #
    # 4) Encontre o DAC através da seguinte expressão:
    #
    #    DAC = 10 - Mod 10 (n)
    #
    # <b>OBS.:</b> Se o resultado do passo 4 for 10, considere o DAC = 0.
    #
    # ==== Exemplos
    #
    # Considerando-se a seguinte representação numérica <b>'12345'</b>.
    #
    # 1) Multiplicando a seqüência de multiplicadores:
    #
    #      1     2     3     4     5
    #      *     *     *     *     *  ===> Multiplicação.
    #      2     1     2     1     2
    #
    # 2) Some, individualmente:
    #
    #      2  +  2  +  6  +  4   + 1 + 0 (Veja a observação abaixo explicando o '1' + '0').
    #      # => 15
    #
    # <b>OBS.:</b>: Resultado da soma que possua 2 digitos deve somar cada dígito.
    # Exemplos: 10 -> 1 + 0. 11 -> 1 + 1, 28 -> 2 + 8, etc.
    #
    # 3) Divida o total encontrado por 10, a fim de determinar o resto da divisão:
    #
    #      15 % 10
    #      # => 5
    #
    # 4) Calculando o DAC:
    #
    #      10 - 5
    #      # => 5 =======> Resultado final retornado.
    #
    class Modulo10 < String
      # @param [String ou Integer] number (Corresponde ao número a ser calculado pelo Módulo 10)
      # @return [String]
      # @example
      #
      #    BoletoBancario::Calculos::Modulo10.new(1233)
      #    # => "6"
      #
      #    BoletoBancario::Calculos::Modulo10.new(4411)
      #    # => "5"
      #
      #    BoletoBancario::Calculos::Modulo10.new('9000')
      #    # => "1"
      #
      #    BoletoBancario::Calculos::Modulo10.new('6789')
      #    # => "2"
      #
      def initialize(number)
        @number  = number
        super(calculate.to_s)
      end

      # @return [String] Resultado final do cálculo do módulo 10.
      #
      def calculate
        sum_total = FatoresDeMultiplicacao.new(@number, fatores: [2, 1]).collect do |result_of_each_sum|
          Digitos.new(result_of_each_sum).sum
        end.sum
        total = 10 - (sum_total % 10)

        return 0 if total.equal?(10)
        total
      end
    end
  end
end