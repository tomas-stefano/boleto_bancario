module BoletoBancario
  module Calculos
    #  === Módulo 11 Fator de 9 a 2 - Resto 10, sendo X
    # <b>Essa classe difere da outra com Modulo11FatorDe9a2, no momento de verificar o resto da divisão por 11.</b>
    #
    # <b>Para mais detalhes veja a classe Modulo11FatorDe9a2.</b>
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
    # @example
    #
    #    BoletoBancario::Calculos::Modulo11FatorDe9a2RestoX.new('184122')
    #    # => 'X'
    #
    class Modulo11FatorDe9a2RestoX < Modulo11FatorDe9a2
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