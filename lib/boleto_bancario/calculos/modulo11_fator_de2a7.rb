module BoletoBancario
  module Calculos
    # === Módulo 11 Fator de 2 a 7
    #
    # === Passos
    #
    # 1) Tomando-se os algarismos multiplique-os, iniciando-se da direita para a esquerda,
    # pela seqüência numérica de 2 a 7 (2, 3, 4, 5, 6, 7 ... e assim por diante).
    #
    # 2) Some o resultado de cada produto efetuado e determine o total como (N).
    #
    # 3) Divida o total (N) por 11 e determine o resto obtido da divisão como Mod 11(N).
    #
    # 4) Calcule o dígito verificador (DAC) através da expressão:
    #
    #     DIGIT = 11 - Mod 11 (n)
    #
    # <b>OBS.:</b> Se o resto da divisão for “1”, desprezar a diferença entre o divisor
    # menos o resto que será “10” e considerar o dígito como “P”.
    #
    # <b>OBS.:</b> Se o resto da divisão for “0”, desprezar o cálculo de subtração entre
    # divisor e resto, e considerar o “0” como dígito.
    #
    # ==== Exemplo
    #
    # Considerando o seguinte número: '89234560'.
    #
    # 1) Multiplicando a seqüência de multiplicadores:
    #
    #      1    9    0    0    0    0    0    0    0    0    0    0    2
    #      *    *    *    *    *    *    *    *    *    *    *    *    *
    #      2    7    6    5    4    3    2    7    6    5    4    3    2
    #
    # 2) Soma-se o resultado dos produtos obtidos no item “1” acima:
    #
    #      2 +  63 + 0  + 0  + 0  + 0  + 0  + 0  + 0  + 0  + 0  + 0  + 4
    #      # => 69
    #
    # 3) Determina-se o resto da Divisão:
    #
    #      69 % 11
    #      # => 3
    #
    # 4) Calcula-se o DAC:
    #
    #      11 - 3
    #      # => 8 =============> Resultado final retornado.
    #
    # @param [String]: Corresponde ao número a ser calculado o Módulo 11 no fator de 2 a 7.
    # @return [String] Retorna o resultado do cálculo descrito acima.
    #
    # @example
    #
    #    BoletoBancario::Calculos::Modulo11FatorDe2a7.new('20')
    #    # => '5'
    #
    #    BoletoBancario::Calculos::Modulo11FatorDe2a7.new('64')
    #    # => '7'
    #
    #    BoletoBancario::Calculos::Modulo11FatorDe2a7.new('26')
    #    # => '4'
    #
    #    BoletoBancario::Calculos::Modulo11FatorDe2a7.new('6')
    #    # => 'P'
    #
    #    BoletoBancario::Calculos::Modulo11FatorDe2a7.new('14')
    #    # => '0'
    #
    class Modulo11FatorDe2a7 < Modulo11
      # Sequência numérica de 2 a 7 que será feito a multiplicação de cada dígito
      # do número passado no #initialize.
      #
      # @return [Array] Sequência numérica
      #
      def fatores
        [2, 3, 4, 5, 6, 7]
      end

      # Calcula o número pelos fatores de multiplicação de 2 a 7.
      # Depois calcula o resto da divisão por 11 e subtrai por 11.
      # Se o resultado desse cálculo for igual a 11, considere DAC = 0.
      # Se o resultado desse cálculo for igual a 10, considere DAC = P.
      #
      # @return [Fixnum]
      #
      def calculate
        return 0 if total.equal?(11)

        if total == 10
          'P'
        else
          total
        end
      end
    end
  end
end