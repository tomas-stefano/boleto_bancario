module BoletoBancario
  module Calculos
    # === Módulo 11 Fator de 9 a 2 - Resto 10, sendo X
    #
    # === Passos
    #
    # 1) Tomando-se os algarismos multiplique-os, iniciando-se da direita para a esquerda,
    # pela seqüência numérica de 9 a 2 (9, 8, 7, 6, 5, 4, 3, 2 ... e assim por diante).
    #
    # 2) Some o resultado de cada produto efetuado e determine o total como (N).
    #
    # 3) Divida o total (N) por 11 e determine o resto obtido da divisão como Mod 11(N).
    #
    # <b>OBS.:</b> Se o resultado desta expressão for igual a 10, considere DAC = X.
    #
    # ==== Exemplo Normal
    #
    # Considerando o seguinte número: '89234560'.
    #
    # 1) Multiplicando a seqüência de multiplicadores:
    #
    #      8    9    2    3    4    5    6    0
    #      *    *    *    *    *    *    *    *
    #      2    3    4    5    6    7    8    9
    #
    # 2) Soma-se o resultado dos produtos obtidos no item “1” acima:
    #
    #      16 + 27 + 8 + 15 + 24 + 35 + 48 + 0
    #      # => 173
    #
    # 3) Determina-se o resto da Divisão:
    #
    #      173 % 11
    #      # => 8 =============> Resultado final retornado.
    #
    # ==== Exemplo 10 como resto da divisão
    #
    # Considerando o seguinte número: '100008'.
    #
    # 1) Multiplicando a seqüência de multiplicadores:
    #
    #      1    0    0    0    0    8
    #      *    *    *    *    *    *
    #      4    5    6    7    8    9
    #
    # 2) Soma-se o resultado dos produtos obtidos no item “1” acima:
    #
    #      4  + 0  + 0  + 0  + 0 + 72
    #      # => 76
    #
    # 3) Determina-se o resto da Divisão:
    #
    #      76 % 11
    #      # => 10
    #
    # 4) Quando o resultado for '10', o dígito será:
    #
    #     resultado == 10
    #     # => 'X' =============> Resultado final retornado.
    #
    # @param [String]: Corresponde ao número a ser calculado o Módulo 11 no fator de 9 a 2.
    # @return [String] Retorna o resultado do cálculo descrito acima.
    #
    # @example
    #
    #    BoletoBancario::Calculos::Modulo11FatorDe9a2RestoX.new('12345')
    #    # => '5'
    #
    #    BoletoBancario::Calculos::Modulo11FatorDe9a2RestoX.new('246')
    #    # => '1'
    #
    #    BoletoBancario::Calculos::Modulo11FatorDe2a9.new('184122')
    #    # => 'X'
    #
    class Modulo11FatorDe9a2RestoX < Modulo11
      # Sequência numérica de 9 a 2 que será feito a multiplicação de cada dígito
      # do número passado no #initialize.
      #
      # @return [Array] Sequência numérica
      #
      def fatores
        [9, 8, 7, 6, 5, 4, 3, 2]
      end

      # Calcula o número pelos fatores de multiplicação de 9 a 2.
      # Depois calcula o resto da divisão por 11.
      # Se o resultado desse cálculo for igual a 10, então o DAC = X.
      # Se o resultado desse cálculo for menor que 10, retornar o resultado.
      #
      # @return [Fixnum]
      #
      def calculate
        if mod_division.equal?(10)
          'X'
        else
          mod_division
        end
      end
    end
  end
end